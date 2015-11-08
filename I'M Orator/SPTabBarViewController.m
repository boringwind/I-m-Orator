//
//  SPTabBarViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPTabBarViewController.h"

#import "CompetitionViewController.h"
#import "ViewController.h"
#import "RankViewController.h"

@interface SPTabBarViewController ()

@end

@implementation SPTabBarViewController


#pragma mark - private

- (UITabBarItem *)_makeItemWithTitle:(NSString *)aTitle normalName:(NSString *)aNormal tag:(NSInteger)aTag
{
    UITabBarItem *result = nil;
    
    UIImage *nor = [UIImage imageNamed:aNormal];
    nor = [nor imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.f) {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor selectedImage:nor];
        [result setTag:aTag];
    } else {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor tag:aTag];
    }
    
    return result;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *aryControllers = [NSMutableArray array];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    /// 参赛页面
    {
        CompetitionViewController *rateController = [storyboard instantiateViewControllerWithIdentifier:@"CompetitionViewController"];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rateController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"参 赛" normalName:@"completion_icon" tag:100];
        [naviController setTabBarItem:item];
        
        [aryControllers addObject:naviController];
    }
    
    /// 评分页面
    {
        ViewController *rateController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rateController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"打 分" normalName:@"rate_icon" tag:101];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    /// 排名页面
    {
        RankViewController *tribeController = [storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:tribeController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"排 名" normalName:@"rank_icon" tag:102];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    self.viewControllers = aryControllers;
    if ([self.tabBar respondsToSelector:@selector(setTintColor:)]) {
        [self.tabBar setTintColor:[UIColor colorWithRed:249.f/255.f green:164.f/255.f blue:50.f/255.f alpha:1.f]];
    }

    [self setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
