//
//  AppDelegate.m
//  I'M Orator
//
//  Created by Wind on 15/10/31.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import "AppDelegate.h"

#import "SVProgressHUD.h"
#import "AccountManager.h"

#import "SPLoginController.h"
#import "SPTabBarViewController.h"

#import "UIImage+ImageEffects.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)getInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)lognOut {
    [AccountManager shareAccountManager].lastUserID = nil;
//    [AccountManager shareAccountManager].lastPassword = nil;
    [AccountManager shareAccountManager].token = nil;
    
    UIViewController *controller = [[SPLoginController alloc] initWithNibName:@"SPLoginController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [UIView transitionWithView:[AppDelegate getInstance].window
                      duration:0.3
                       options:(UIViewAnimationOptionTransitionCrossDissolve
                                | UIViewAnimationOptionAllowAnimatedContent)
                    animations:^{
                        [AppDelegate getInstance].window.rootViewController = nvc;
                    }
                    completion:^(BOOL finished) {
                    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // App可以相应摇晃手势
    application.applicationSupportsShakeToEdit = YES;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    UIColor *navBarColor = [UIColor colorWithRed:249.f/255.f green:164.f/255.f blue:50.f/255.f alpha:1.f];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:navBarColor]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSShadow *clearShadow = [[NSShadow alloc] init];
    clearShadow.shadowColor = [UIColor clearColor];
    clearShadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary *textAttributes = @{
                                     NSParagraphStyleAttributeName : paragraphStyle,
                                     NSShadowAttributeName : clearShadow,
                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:18.f]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    if ([AccountManager shareAccountManager].lastUserID != nil
//        && [AccountManager shareAccountManager].lastPassword != nil
        && [AccountManager shareAccountManager].token != nil) {
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        SPTabBarViewController *tabController = [[SPTabBarViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tabController];
        self.window.rootViewController = nvc;
        [self.window makeKeyAndVisible];
    }
    else {
    
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *controller = [[SPLoginController alloc] initWithNibName:@"SPLoginController" bundle:nil];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = nvc;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
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
