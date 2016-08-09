//
//  VideoViewController.m
//  新闻
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//推荐页面控制器

#import "RecommendedViewController.h"
#import "Common.h"
#import "ThisHeader.h"
#import "SVProgressHUD.h"

@interface RecommendedViewController ()
@property (nonatomic ,strong) AFHTTPSessionManager *manager;
@property (nonatomic ,assign) NSInteger pageNumber;
@property (nonatomic ,strong) NSMutableArray *arrItem;
//@property (nonatomic ,strong) UIButton *footBtn;
@end

@implementation RecommendedViewController
static NSString *normalIDF = @"docCell";
static NSString *slidesIDF = @"slidesCell";

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        //创建manager对象
        _manager = [AFHTTPSessionManager manager];
        //设置网络监听
        _manager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_manager.reachabilityManager startMonitoring];
    }
    return _manager;
}
//获取数据
-(void)getNewsData{
    __weak typeof(self) weakSelf = self;
    [self.refreshControl endRefreshing];
    [self.manager GET:BASEURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@">>>%@",responseObject);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode != 200)  return ;
        NSArray *newsItem = responseObject[mdStrItem];
        NSMutableArray *arrTemp = [NSMutableArray array];
        for (NSDictionary *dict in newsItem) {
            ModelItem *itemModel = [ModelItem modelWithDictionary:dict];
            if ([itemModel.strType isMemberOfClass:[NSNull class]]) {
                return;
            }
            if ([itemModel.strType isEqualToString:@"doc"]) {
                [arrTemp addObject:itemModel];
            };
        }
        [self.arrItem addObjectsFromArray:arrTemp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败？？？%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.scrollsToTop = YES;
    self.navigationController.navigationBar.translucent = NO;
    //先给存放数据的数组分配内存
    if (_arrItem == nil) {
        _arrItem = [NSMutableArray array];
    }
    //加载数据
    [self getNewsData];
    //注册单元格
    NSString *slidesNibName = NSStringFromClass([NewsCell class]);
    UINib *secondNib = [UINib nibWithNibName:slidesNibName bundle:nil];
    [self.tableView registerNib:secondNib forCellReuseIdentifier:normalIDF];
    //下拉刷新
    self.refreshControl  = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downLoadMore) forControlEvents:UIControlEventValueChanged];
    //Loading按钮
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setTitle:@"加载更多..." forState:UIControlStateNormal];
    //加载更多
    [footBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [footBtn addTarget:self action:@selector(upLoadMore) forControlEvents:UIControlEventTouchUpInside];
    footBtn.frame = CGRectMake(0, 0, 0, 0);
//    _footBtn = footBtn;
//    self.tableView.tableFooterView = footBtn;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark - 下拉刷新 及点击加载更多

-(void)downLoadMore{//下拉刷新
    [self getNewsData];
}

-(void)upLoadMore{//点击加载更多
    [SVProgressHUD showWithStatus:@"拼命加载中..."];
    [self getNewsData];
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.origin.y) animated:YES];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        sleep(1.0);
        [self upLoadMore];
    }
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//当前section中有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrItem.count;
}
////在IndexPath位置显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ModelItem *modelItem = self.arrItem[indexPath.row];
    if ([modelItem.strType isEqualToString:@"doc"]) {
        NewsCell *publicCell = [NewsCell newsCellWithTableView:tableView];
        publicCell.model = modelItem;
        return publicCell;
    }else{
        NewsCell *cell = [NewsCell newsCellWithTableView:tableView];
        cell.model = modelItem;
        return cell;
    }
}
#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelItem *itemModel = self.arrItem[indexPath.row];
    if ([itemModel.strType isEqualToString:@"doc"]) {
        WebViewVC *detailsVC = [WebViewVC new];
        detailsVC.modelItem = itemModel;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
@end
