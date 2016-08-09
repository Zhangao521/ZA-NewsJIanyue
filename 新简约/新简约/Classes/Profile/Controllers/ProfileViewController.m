//
//  ProfileViewController.m
//  新闻
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ProfileViewController.h"
#import "ThisHeader.h"
#import "TableViewHeaderView.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchON;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled =NO;
    [self.tableView setSeparatorColor:[UIColor grayColor]];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 0,40, 30)];
    [titleBtn setTitle:@"设置" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView addSubview:titleBtn];
    self.tableView.tableHeaderView = headerView;

}
#pragma mark - 自定义tableViewHeaderView
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)swithAction:(UISwitch *)sender {
    if (_switchON.isOn) {
        self.tabBarController.view.alpha = 0.4;
//        [UIApplication sharedApplication].delegate.window.alpha = 0.4;
    }else{
        self.tabBarController.view.alpha = 1;
//         [UIApplication sharedApplication].delegate.window.alpha = 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新简约1.0" message:[NSString stringWithFormat:@"本APP所收集的部分公开资料来源于互联网，转载的目的在于传递更多信息及用于网络分享，并不代表本站赞同其观点和对其真实性负责，也不构成任何其他建议。如果您发现网站上有侵犯您的知识产权的作品，请与我们取得联系，我们会及时修改或删除。\n"] preferredStyle:1];
        UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:canceAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        UIAlertController *alertMD = [UIAlertController alertControllerWithTitle:@"提示:" message:[NSString stringWithFormat:@"缓存内容大小为%.2fM.你确定清理缓存吗?",size/1024.0/1024.0] preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [[SDImageCache sharedImageCache]clearDisk];
            [self.tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertMD addAction:okAction];
        [alertMD addAction:cancelAction];
        [self presentViewController:alertMD animated:YES completion:nil];
    }
     if (indexPath.row == 3){
        UIAlertController *lastAlert = [UIAlertController alertControllerWithTitle:@"新简约 1.0" message:@"©版权归属开发者所有,更多精彩,敬请期待!" preferredStyle:1];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [lastAlert addAction:action];
        [self presentViewController:lastAlert animated:YES completion:nil];
    }

}
@end
