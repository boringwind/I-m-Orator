//
//  SPLoginController.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPLoginController.h"

#import "AppDelegate.h"
#import "SPTabBarViewController.h"

#import "AccountManager.h"
#import "SyncHelper.h"
#import "SVProgressHUD.h"

#import "UIImage+Screenshot.h"
#import "UIImage+ImageEffects.h"

@interface SPLoginController () <UIActionSheetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *viewOperator;
@property (weak, nonatomic) IBOutlet UIView *viewInput;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIImageView *userNameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

/// for iPad
@interface SPLoginController () <UISplitViewControllerDelegate>

@property (nonatomic, weak) UINavigationController *weakDetailNavigationController;

@end

@implementation SPLoginController

#pragma mark - public

- (void)addNotifications
{
    /// 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)pushMainControllerAnimated:(BOOL)aAnimated
{
    if (self.navigationController.topViewController != self) {
        /// 已经进入主页面
        return;
    }
    
    SPTabBarViewController *tabController = [[SPTabBarViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tabController];
    
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

- (void)tryLogin
{
    if (self.textFieldUserID.text.length == 0) {
        return;
    }
    
    __weak SPLoginController *weakSelf = self;
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SyncHelper shareSyncHelper] loginWithUsername:self.textFieldUserID.text
                                             completion:^(NSDictionary *resultDictionary){

                                                 if ([resultDictionary.allKeys containsObject:@"code"]) {
                                                     NSNumber *code = resultDictionary[@"code"];
                                                     if ([code integerValue] == 1) {
                                                         [SVProgressHUD dismiss];
                                                         [AccountManager shareAccountManager].lastUserID = self.textFieldUserID.text;
                                                         //                                                     [AccountManager shareAccountManager].lastPassword = self.textFieldPassword.text;
                                                         
                                                         // 登录成功
                                                         [weakSelf pushMainControllerAnimated:YES];
                                                         return ;
                                                     }
                                                 }
                                                 
                                                 [SVProgressHUD showErrorWithStatus:@"登录失败，请先确认您的账户"];
                                             }
                                                  error:^(NSError *error){
                                                      [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                                                  }];
    });
}

#pragma mark - properties

+ (NSString *)lastUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUserID"];
}

+ (void)setLastUserID:(NSString *)lastUserID
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:@"lastUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPassword"];
}

+ (void)setLastPassword:(NSString *)lastPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:@"lastPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - life circle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // 初始化
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Login"];
    
    UIColor *mainColor = [UIColor colorWithRed:168.f/255.f green:29.f/255.f blue:32.f/255.f alpha:1.f];
    
    UIImage *userNameImage = [UIImage imageNamed:@"user_name_icon"];
    userNameImage = [userNameImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.userNameImageView.image = userNameImage;
    self.userNameImageView.tintColor = mainColor;
    
    UIImage *passwordImage = [UIImage imageNamed:@"password_icon"];
    passwordImage = [passwordImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.passwordImageView.image = passwordImage;
    self.passwordImageView.tintColor = mainColor;
    
    [self.viewInput.layer setBorderWidth:0.5f];
    [self.viewInput.layer setBorderColor:mainColor.CGColor];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.backgroundImageView.image = [[UIImage screenshotCapturedWithinView:self.backgroundImageView]
                                            applyBlurWithRadius:
                                            12 tintColor:[UIColor colorWithRed:178.f/255.f green:181.f/255.f blue:168.f/255.f alpha:0.3f]
                                            saturationDeltaFactor:1
                                            maskImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions

- (IBAction)actionLogin:(id)sender
{
    [self.view endEditing:YES];
    
    [self tryLogin];
}

- (IBAction)actionBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionSignup:(id)sender {
    
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:1.0];
    //因为没给viewController类添加成员变量，所以用下面方法得到viewDidLoad添加的子视图
    UIView *parentView = self.viewOperator;
    //设置动画效果
     [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:parentView cache:YES];  //从左向右
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //提交动画
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldUserID) {
        [self tryLogin];
    }
    return YES;
}

#pragma mark - notifications

static NSValue *sOldCenter = nil;

- (void)onKeyboardWillShowNotification:(NSNotification *)aNote
{
    if (sOldCenter == nil) {
        sOldCenter = [NSValue valueWithCGPoint:self.viewOperator.center];
    }
    
    CGRect keyboardFrame = [aNote.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint toPoint = CGPointMake(self.view.center.x, self.view.center.y - keyboardFrame.size.height + 30);
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.viewOperator setCenter:toPoint];
    }];
}

- (void)onKeyboardWillHideNotification:(NSNotification *)aNote
{
    if (sOldCenter) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.viewOperator setCenter:sOldCenter.CGPointValue];
        }];
    }
}

#pragma mark - UISplitViewController delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  NS_DEPRECATED_IOS(5_0, 8_0, "Use preferredDisplayMode instead")
{
    return NO;
}

@end
