//
//  SecondViewController.m
//  新简约
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "WebViewVC.h"
#import "ThisHeader.h"

@interface WebViewVC ()<UIWebViewDelegate>
/** 选中行的webView */
@property (nonatomic ,strong) UIWebView *newsWebView;
/** 请求数据对象 */
@property (nonatomic ,strong) AFHTTPSessionManager *manager;

@end

@implementation WebViewVC
#pragma mark - 懒加载webView
-(UIWebView *)newsWebView{
    if (!_newsWebView) {
        UIWebView *webView = [[UIWebView alloc] init];
        _newsWebView = webView;
    }
    return _newsWebView;
}

#pragma mark - 懒加载请求数据的对象
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json", nil];
        _manager = manager;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"拼命加载中..."];
    self.newsWebView.frame = [UIScreen mainScreen].bounds;
//    CGRect customFrame = self.newsWebView.frame;
//    customFrame.size.height -=110;
//    self.newsWebView.frame = customFrame;
    [self.view addSubview:self.newsWebView];
    self.newsWebView.backgroundColor = [UIColor grayColor];
    self.newsWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.newsWebView.delegate = self;
    [self reloadUI];
    [self reloadInputViews];
    
}

-(void)reloadUI{
    [self.manager GET:self.modelItem.strHotLink parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            NSString *strText = responseObject[@"body"][@"text"];
            strText = [strText stringByReplacingOccurrencesOfString:@"网易" withString:@"新闻"];
            if (strText) {
                [self.newsWebView loadHTMLString:strText baseURL:nil];
                [SVProgressHUD dismiss];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //按百分比修改字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body') [0].style.webkitTextSizeAdjust= '110%"];
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    
    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width - 10];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];

}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
