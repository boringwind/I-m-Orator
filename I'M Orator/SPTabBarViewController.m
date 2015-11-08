//
//  SPTabBarViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPTabBarViewController.h"
#import "SPKitExample.h"


#import "SPContactListController.h"
#import "SPTribeListViewController.h"
#import "SPSettingController.h"
#import "SPUtil.h"


#define kTabbarItemCount    4

@interface SPTabBarViewController ()

@end

@implementation SPTabBarViewController


#pragma mark - private

- (UITabBarItem *)_makeItemWithTitle:(NSString *)aTitle normalName:(NSString *)aNormal selectedName:(NSString *)aSelected tag:(NSInteger)aTag
{
    UITabBarItem *result = nil;
    
    UIImage *nor = [UIImage imageNamed:aNormal];
    UIImage *sel = [UIImage imageNamed:aSelected];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.f) {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor selectedImage:sel];
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
    
    /// 会话列表页面
    {
        __weak typeof(self) weakSelf = self;
        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance] exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
            if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
                [aConversation markConversationAsRead];
                
                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/"];
                __weak typeof(controller) weakController = controller;
                [controller setViewWillAppearBlock:^(BOOL aAnimated) {
                    [weakController.navigationController setNavigationBarHidden:NO animated:aAnimated];
                }];
                [controller setHidesBottomBarWhenPushed:YES];
                [controller setTitle:@"功能介绍"];
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation fromNavigationController:weakSelf.navigationController];
            }
        }];
        
        // 会话列表空视图
        if (conversationListController)
        {
            CGRect frame = CGRectMake(0, 0, 100, 100);
            UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
            imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
            [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            
            [viewForNoData addSubview:imageView];
            
            conversationListController.viewForNoData = viewForNoData;
        }
        
        {
            // 隐藏会话列表右导航按钮
//            __weak typeof(conversationListController) weakController = conversationListController;
//            [conversationListController setViewDidLoadBlock:^{
//                weakController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomConversation)];
//            }];
        }


        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:conversationListController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"消息" normalName:@"news_nor" selectedName:@"news_pre" tag:100];
        [naviController setTabBarItem:item];
        
        [aryControllers addObject:naviController];
    }
    
    // 先隐藏掉
    /// 联系人列表页面
    {
//        SPContactListController *contactListController = [[SPContactListController alloc] initWithNibName:@"SPContactListController" bundle:nil];
//        
//        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:contactListController];
//        
//        UITabBarItem *item = [self _makeItemWithTitle:@"联系人" normalName:@"contact_nor" selectedName:@"contact_pre" tag:101];
//        [naviController setTabBarItem:item];
//
//        [aryControllers addObject:naviController];
    }
    
    /// 群页面
    {
        SPTribeListViewController *tribeController = [[SPTribeListViewController alloc] init];
        
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:tribeController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"群列表" normalName:@"group_nor" selectedName:@"group_pre" tag:102];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    /// 设置页面
    {
        SPSettingController *settingController = [[SPSettingController alloc] initWithNibName:@"SPSettingController" bundle:nil];
        
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:settingController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"更多" normalName:@"set_nor" selectedName:@"set_pre" tag:103];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    self.viewControllers = aryControllers;
    
    
    if ([self.tabBar respondsToSelector:@selector(setTintColor:)]) {
        [self.tabBar setTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
    }
}

- (void)addCustomConversation
{
    // todo
    [[SPKitExample sharedInstance] exampleAddOrUpdateCustomConversation];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
