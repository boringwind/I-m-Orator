//
//  SPLoginController.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPLoginController.h"

#import "SPKitExample.h"
#import "SPUtil.h"

#import "AppDelegate.h"
#import "SPTabBarViewController.h"

#import "AccountManager.h"
#import "SyncHelper.h"
#import "SVProgressHUD.h"

@interface SPLoginController ()
<UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewOperator;
@property (weak, nonatomic) IBOutlet UIView *viewInput;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@property (nonatomic, assign) BOOL isLogin;

/**
 *  获取随机游客账号
 */
- (void)_getVisitorUserID:(NSString **)aGetUserID password:(NSString **)aGetPassword;


@end


/// for iPad
@interface SPLoginController ()
<UISplitViewControllerDelegate>

@property (nonatomic, weak) UINavigationController *weakDetailNavigationController;

@end

@implementation SPLoginController

#pragma mark - public

+ (void)getLastUserID:(NSString *__autoreleasing *)aUserID lastPassword:(NSString *__autoreleasing *)aPassword
{
    if (aUserID) {
        *aUserID = [self lastUserID];
    }
    
    if (aPassword) {
        *aPassword = [self lastPassword];
    }
}

#pragma mark - private

- (void)_getVisitorUserID:(NSString *__autoreleasing *)aGetUserID password:(NSString *__autoreleasing *)aGetPassword
{
    if (aGetUserID) {
        *aGetUserID = [NSString stringWithFormat:@"visitor%d", arc4random()%1000+1];
    }
    
    if (aGetPassword) {
        *aGetPassword = [NSString stringWithFormat:@"taobao1234"];
    }
}

- (void)_presentSplitControllerAnimated:(BOOL)aAnimated
{
    if (self.navigationController.topViewController != self) {
        /// 已经进入主页面
        return;
    }
    
    UISplitViewController *splitController = [[UISplitViewController alloc] init];
    
    if ([splitController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        [splitController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    
    /// 各个页面
    
    UINavigationController *masterController = nil, *detailController = nil;
    
    {
        /// 消息列表页面
        
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view setBackgroundColor:[UIColor whiteColor]];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        detailController = nvc;
    }
    
    
    
    
    {
        /// 会话列表页面
        __weak typeof(self) weakSelf = self;
        self.weakDetailNavigationController = detailController;
        
        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance] exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
            
            if ([weakSelf.weakDetailNavigationController.viewControllers.lastObject isKindOfClass:[YWConversationViewController class]]) {
                YWConversationViewController *oldConvController = weakSelf.weakDetailNavigationController.viewControllers.lastObject;
                if ([oldConvController.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                    return;
                }
            }

            
            YWConversationViewController *convController = [[SPKitExample sharedInstance] exampleMakeConversationViewControllerWithConversation:aConversation];
            if (convController) {
                [weakSelf.weakDetailNavigationController popToRootViewControllerAnimated:NO];
                [weakSelf.weakDetailNavigationController pushViewController:convController animated:NO];
                
                /// 关闭按钮
                UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(actionCloseiPad:)];
                [convController.navigationItem setLeftBarButtonItem:closeItem];
            }
        }];
        
        masterController = [[UINavigationController alloc] initWithRootViewController:conversationListController];
        
        /// 注销按钮
        UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogoutiPad:)];
        [conversationListController.navigationItem setLeftBarButtonItem:logoutItem];
    }

    [splitController setViewControllers:@[masterController, detailController]];
    
    [self presentViewController:splitController animated:aAnimated completion:NULL];
}

- (void)_addNotifications
{
    /// 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)_pushMainControllerAnimated:(BOOL)aAnimated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self _presentSplitControllerAnimated:aAnimated];
    } else {
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
}

- (void)_tryLogin
{
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    // 这里先进行应用的登录
    NSDictionary *resultDic = nil;
    if (self.isLogin) {
        resultDic = [[SyncHelper shareSyncHelper] loginWithUsername:self.textFieldUserID.text password:self.textFieldPassword.text];
    }
    else {
        resultDic = [[SyncHelper shareSyncHelper] registerWithUsername:self.textFieldUserID.text password:self.textFieldPassword.text];
    }
    
    if (resultDic == nil) {
        [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
        return;
    }
    
    if ([resultDic[@"code"] isEqualToString:@"success"]) {
        
        NSString *openIMUsername = resultDic[@"username"];
        NSString *openIMPassword = resultDic[@"password"];
        
        [[AccountManager shareAccountManager] setOpenIMUserID:openIMUsername];
        [[AccountManager shareAccountManager] setOpenIMPassword:openIMPassword];
        
        [SPLoginController setLastUserID:self.textFieldUserID.text];
        [SPLoginController setLastPassword:self.textFieldPassword.text];
        
        // 应用登陆成功后，登录IMSDK
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:openIMUsername
                                                                               passWord:openIMPassword
                                                                        preloginedBlock:^{
                                                                            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                                                            [weakSelf _pushMainControllerAnimated:YES];
                                                                        } successBlock:^{
                                                                            
                                                                            //  到这里已经完成SDK接入并登录成功，你可以通过exampleMakeConversationListControllerWithSelectItemBlock获得会话列表
                                                                            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                                                            [weakSelf _pushMainControllerAnimated:YES];
                                                                            
                                                                        } failedBlock:^(NSError *aError) {

                                                                            if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                                                                            }
                                                                        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:resultDic[@"msg"]];
    }
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
    
    [self.viewInput.layer setBorderWidth:0.5f];
    [self.viewInput.layer setBorderColor:[UIColor colorWithRed:0.f green:180.f/255.f blue:255.f/255.f alpha:1.f].CGColor];
    
    self.isLogin = YES;
    [self refreshContents];
    
    [self _addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - actions

- (IBAction)actionLogin:(id)sender
{
    [self.view endEditing:YES];
    
    [self _tryLogin];
}

- (IBAction)actionBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionSignup:(id)sender {
    self.isLogin = !self.isLogin;
    [self performSelector:@selector(refreshContents) withObject:nil afterDelay:0.2f];
    
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

- (void)refreshContents
{
    if (self.isLogin) {
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.signupButton setTitle:@"没有账号？还在犹豫什么" forState:UIControlStateNormal];
    }
    else {
        [self.loginButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.signupButton setTitle:@"已有账号！立马去飞" forState:UIControlStateNormal];
    }
}

- (IBAction)actionLogoutiPad:(id)sender
{
    [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)actionCloseiPad:(id)sender
{
    [self.weakDetailNavigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)actionVisitor:(id)sender {
    NSString *userID = nil, *password = nil;
    [self _getVisitorUserID:&userID password:&password];
    
    [self actionLogin:nil];
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
