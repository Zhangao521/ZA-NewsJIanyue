//
//  AppDelegate.m
//  新闻1
//
//  Created by qingyun on 16/7/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "MainViewController.h"
#import "ThisHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 1. 获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2. 设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [SVProgressHUD showInfoWithStatus:@"未知网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showInfoWithStatus:@"请检查你的网络设置!"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [SVProgressHUD showInfoWithStatus:@"你正在使用手机网络!"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [SVProgressHUD showSuccessWithStatus:@"WIFI已连接"];
                break;
        }
    }];
    
    // 3. 开始监控
    [manager startMonitoring];

        //根据条件设置根视图控制器
        //1,从info.plist文件中读取当前的外部版本号
        NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        //读取自己上一次运行引导页保存的版本号
        NSString *strVersionMain = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldVersionKey"];
        //判断两个版本号是否相同
        if ([strVersion isEqualToString:strVersionMain]) {//版本号相同时 直接跳转主控制器
            [self loadMainController];
        }else{ //版本不相同 进入引导页
            [_window setRootViewController:[[GuideViewController alloc] init]];
        }
        [_window makeKeyAndVisible];
    return YES;
}

-(void)loadMainController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *vcTabBar = [sb instantiateViewControllerWithIdentifier:@"haha"];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcTabBar];
    vcTabBar.navigationController.navigationBar.translucent = NO;
    [_window setRootViewController:vcTabBar];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
