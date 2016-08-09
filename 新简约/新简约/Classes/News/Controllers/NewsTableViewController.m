//
//  TableViewController.m
//  news_APP
//
//  Created by qingyun on 16/5/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ThisHeader.h"
#import "SVProgressHUD.h"
@interface NewsTableViewController ()

@property (nonatomic)        NSInteger newsPage; // 标题的页码
@property (nonatomic ,strong)AFHTTPSessionManager *manager;
@property (nonatomic ,strong)NSMutableArray *itemArray;    //新闻数组(内部为itemModel模型)
@property (nonatomic ,strong)NSMutableArray *focusArray;   //头部滚动视图数据
@property (nonatomic ,assign)NSInteger pageNumber;
@property (nonatomic ,strong) UIButton *footBtn;
@end

@implementation NewsTableViewController

static NSString *normalIDF = @"normalCell";
//static NSString *slidesIDF = @"slidesCell";

#pragma -mark AFHTTPSessionManager 从网络请求数据
-(AFHTTPSessionManager *)manager {
    if (!_manager) {
        //创建manager对象
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}
//获取数据 （）
-(void)getNewsData:(NSDictionary *)page{
    __weak typeof(self) weakSelf = self;
    [self.refreshControl endRefreshing];
    [self.manager GET:_newsUrlsKey parameters:page progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSLog(@"===%@》》》",responseObject);
        if ( response.statusCode != 200) return ;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *newsItems = (NSArray *)responseObject;
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *tempArray1 = [NSMutableArray array];
            NSInteger responsePage = [responseObject[0][@"currentPage"] integerValue];
            if (responsePage != _pageNumber) return ;
            for (NSDictionary *dict in newsItems) {
                if ([dict[mdStrTpye] isEqualToString:@"list"]) {
                    NSArray *items = dict[mdStrItem];
                    for (NSDictionary *NewsItem in items) {
                        ModelItem *SSItemModel = [ModelItem modelWithDictionary:NewsItem];
                        if ([SSItemModel.strType isMemberOfClass:[NSNull class]]) {
                            return;
                        }
                        if ([SSItemModel.strType isEqualToString:@"doc"]) {
                            [tempArray addObject:SSItemModel];
                        };
                    }
                }
                if ([dict[mdStrTpye] isEqualToString:@"focus"]) {
                    NSArray *focus = dict[mdStrItem];
                    for (NSDictionary *focusDict in focus) {
                        ModelItem *SSFocusModel = [ModelItem modelWithDictionary:focusDict];
                        [tempArray1 addObject:SSFocusModel];
                    }
                }
            }
            NSString *tempStr1 = ((ModelItem *)(tempArray.firstObject)).strTitle;
            NSString *tempStr2 = ((ModelItem *)(self.itemArray.firstObject)).strTitle;
            if (![tempStr1 isEqualToString:tempStr2]){
                [self.itemArray addObjectsFromArray:tempArray];
            }
            
            NSString *tempStr3 = ((ModelItem *)(tempArray.firstObject)).strTitle;
            NSString *tempStr4 = ((ModelItem *)(self.itemArray.firstObject)).strTitle;
            if ([tempStr3 isEqualToString:tempStr4]){
                self.focusArray = nil;
            }
            self.focusArray = tempArray1;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.focusArray.count > 0) { //添加tableView的头部滚动视图
//                    [weakSelf addScrollView];
                }
                [weakSelf.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败？？？%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 120;
    //先给存放数据的数组分配内存
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    if (_focusArray == nil) {
        _focusArray = [NSMutableArray array];
    }
    //注册单元格(利用nib文件来注册NormalTableViewCell)
    NSString *slidesNibName = NSStringFromClass([NewsCell class]);
    UINib *nib = [UINib nibWithNibName:slidesNibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:normalIDF];
    //加载数据
    _pageNumber = 1;
    NSDictionary *page = @{@"page":@(_pageNumber)};
    
    [self getNewsData:page];
    //下拉刷新
    self.refreshControl  = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downLoadMore) forControlEvents:UIControlEventValueChanged];
    //Loading按钮
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [footBtn setTitle:@"松手之后加载更多..." forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [footBtn addTarget:self action:@selector(upLoadMore) forControlEvents:UIControlEventTouchUpInside];    
    footBtn.frame = CGRectMake(0, 0, 0, 40);
//    self.tableView.tableFooterView = footBtn;
    _footBtn = footBtn;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)downLoadMore{//下拉刷新
    NSDictionary *page = @{@"page":@(1)};
    [self getNewsData:page];
}
-(void)upLoadMore{//上拉加载
    [SVProgressHUD showWithStatus:@"加载中..."];
    _pageNumber ++ ;
    NSDictionary *page = @{@"page":@(_pageNumber)};
    [self getNewsData:page];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [_footBtn setTitle:@"松手之后加载更多..." forState:UIControlStateNormal];
    }else{
        [_footBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        sleep(1.0);
        [self upLoadMore];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self reloadInputViews];
    ModelItem *itemModel = self.itemArray[indexPath.row];
    
    if ([itemModel.strType isEqualToString:@"doc"]) {
        NewsCell *slidesCell = [NewsCell newsCellWithTableView:tableView];
        slidesCell.model = itemModel;
        return slidesCell;
    }else{
        NewsCell *cell = [NewsCell newsCellWithTableView:tableView];
        cell.model = itemModel;
        return cell;
    }
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//选中行，压栈
    ModelItem *itemModel = self.itemArray[indexPath.row];
    
    if ([itemModel.strType isEqualToString:@"doc"]) {
        WebViewVC *detailsVC = [WebViewVC new];
        detailsVC.modelItem = itemModel;
        [self.navigationController pushViewController:detailsVC animated:YES];
//        [self reloadInputViews];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
