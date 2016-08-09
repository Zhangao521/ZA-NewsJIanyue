//
//  NewsPageViewController.m
//  news_APP
//
//  Created by qingyun on 16/5/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "ThisHeader.h"

@interface NewsPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic ,strong) PublicCollectionView *PublicCollectionView;     //头部滑动collectionView
@property (nonatomic ,strong) NewsTableViewController * tableViewController;//内容tableVC

@property (nonatomic ,strong) NSArray *collectionViewTitle;
@end
@implementation NewsPageViewController

//collectionViewTitle
-(NSArray *)collectionViewTitle{
    if (_collectionViewTitle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"newsTitle" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mutArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TitleModel  *titlesModel = [TitleModel modelWithDictionary:dic];
            [mutArray addObject:titlesModel];
        }
        _collectionViewTitle = mutArray;
    }
    return _collectionViewTitle;
}

//懒加载PublicCollectionView
-(PublicCollectionView *)PublicCollectionView{
    if (_PublicCollectionView == nil) {
        _PublicCollectionView = [PublicCollectionView titleCollectionViewWithTitles:self.collectionViewTitle];
        //        __weak NewsPageViewController *weakSelf = self;
        __weak typeof(self) weakSelf = self;
        _PublicCollectionView.changeContentVC = ^(NSUInteger index){
            //更改内容控制器
            [weakSelf changeContentViewControllerWithIndex:index];
        };
    }
    
    return _PublicCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置 pageViewController的数据源和代理
    self.delegate = self;
    self.dataSource = self;
    NewsTableViewController *contentVC = [self viewControllerWithIndex:0];
    [self setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    //设置导航栏
    self.navigationItem.titleView = self.PublicCollectionView;       _PublicCollectionView.frame = CGRectMake(0, 0, 375, 40);
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
}
//根据选中的栏目的索引来更改内容控制器
-(void)changeContentViewControllerWithIndex:(NSUInteger)index{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NewsTableViewController *currentTBVC = self.viewControllers.firstObject;
    NSUInteger currentIndex = currentTBVC.indexNumber;
    //2.currentIndex == index,return;
    if (currentIndex == index) {
        return;
    }
    //3.根据index获取对应的内容控制器,然后设置内容控制器
    NewsTableViewController *willChangedVC = [self viewControllerWithIndex:index];
    [self setViewControllers:@[willChangedVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
//根据索引获取内容控制器
-(NewsTableViewController *)viewControllerWithIndex:(NSUInteger)index{
    if (self.collectionViewTitle.count == 0 || index >= self.collectionViewTitle.count) {
        return nil;
    }
    NewsTableViewController *tableVC = [NewsTableViewController new];
    TitleModel *titleModel = self.collectionViewTitle[index];
    //; //ModelItem
    //    titleModel.species = [self.collectionViewTitle[index] strLink];
    //    titleModel.url = [self.collectionViewTitle[index] strID];
    tableVC.indexNumber = index;
    tableVC.newsUrlsKey = titleModel.url;
    
    return tableVC;
}
#pragma mark  -UIPageViewControllerDataSource
//上一个内容控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger currentIndex = ((NewsTableViewController *)viewController).indexNumber;
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex -= 1;
    //根据currentIndex获取上一个内容控制器
    return [self viewControllerWithIndex:currentIndex];
}
//下一个内容控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger currentIndex = ((NewsTableViewController *)viewController).indexNumber;
    currentIndex++;
    if (currentIndex >= self.collectionViewTitle.count) {
        return nil;
    }
    return [self viewControllerWithIndex:currentIndex];
}
#pragma mark -UIPageViewControllerDelegate
//结束过渡动画
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NewsTableViewController *currentDataVC = self.viewControllers.firstObject;
    NSUInteger currentIndex = currentDataVC.indexNumber;
    //2.获取上一个内容控制器的type在titles中的索引previousIndex
    NSUInteger previousIndex = ((NewsTableViewController *)previousViewControllers.firstObject).indexNumber;
    //3.判断currentIndex != previousIndex,设置_PublicCollectionView的currentIndex等于currentIndex
    if (currentIndex != previousIndex) {
        _PublicCollectionView.currentIndex = currentIndex;
    }
}

@end
