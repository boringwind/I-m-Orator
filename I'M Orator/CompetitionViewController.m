//
//  CompetitionViewController.m
//  I'M Orator
//
//  Created by Wind on 15/11/1.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import "CompetitionViewController.h"

#import "SyncHelper.h"
#import "SVProgressHUD.h"

#define DEFAULT_ORDER -1

@interface CompetitionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shakeImageView;

@property (nonatomic, assign) BOOL requestDoing;

@property (nonatomic, assign) NSNumber *order;
@property (nonatomic, assign) BOOL requestFinished;
@property (nonatomic, assign) BOOL shakeFinished;

@end

@implementation CompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"参  赛";
    self.order = @(-1);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self becomeFirstResponder];
    
    self.requestDoing = NO;
    self.requestFinished = NO;
    self.shakeFinished = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
}

#pragma mark - 检测晃动

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)doShakeImageAnimation {
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = [NSNumber numberWithFloat:-0.3];
    momAnimation.toValue = [NSNumber numberWithFloat:0.3];
    momAnimation.duration = 0.2;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;
    [self.shakeImageView.layer addAnimation:momAnimation forKey:@"animateLayer"];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {

        if (self.requestDoing == YES || [self.order integerValue] != DEFAULT_ORDER) {
            // 正在从服务器获取自己的Order, 或是已经获取过自己的Order了
            return;
        }

        [self doShakeImageAnimation];
        self.requestFinished = NO;
        self.shakeFinished = NO;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        // 调用网络请求
        [[SyncHelper shareSyncHelper] getOrderCompletion:^(NSDictionary *resultDictionary) {
            self.requestFinished = YES;
            if ([resultDictionary.allKeys containsObject:@"code"]) {
                // 失败了
            }
            else {
                self.order = resultDictionary[@"order"];
            }
            [self endShakeOrRequest];
        }
                                                   error:^(NSError *error) {
                                                       self.requestFinished = YES;
                                                       [self endShakeOrRequest];
                                                   }];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.shakeFinished = YES;
        [self resignFirstResponder];
        [self endShakeOrRequest];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.shakeFinished = YES;
        [self resignFirstResponder];
        [self endShakeOrRequest];
    }
}

- (void)endShakeOrRequest {
    
    if (self.shakeFinished && self.requestFinished) {

        // 已停止晃动手机, 且网络请求也已经结束
        [self.shakeImageView.layer removeAnimationForKey:@"animateLayer"];
        self.tabBarController.tabBar.userInteractionEnabled = YES;

        if ([self.order integerValue] == DEFAULT_ORDER) {
            [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
            return;
        }
     
        UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:[NSString stringWithFormat:@"你的参赛编号是：%ld", [self.order integerValue]]
                                      delegate:nil
                             cancelButtonTitle:@"我记下了"
                             otherButtonTitles:nil];
        [alertView show];
    }
}

@end
