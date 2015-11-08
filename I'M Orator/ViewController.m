//
//  ViewController.m
//  I'M Orator
//
//  Created by Wind on 15/10/31.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import "ViewController.h"

#import "RateTableViewCell.h"
#import "CenterTitleTableViewCell.h"

#import "AccountManager.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SyncHelper.h"

#import "RankDataModel.h"

#import "Masonry.h"

#import "UIImage+Screenshot.h"
#import "UIImage+ImageEffects.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *rateTitles;
@property (nonatomic, strong) NSArray *rateDataModels;

@property (nonatomic, strong) CenterTitleCellDataModel *submitDataModel;

@property (nonatomic, strong) NSArray *contestantDataModels;

// 选择参赛者
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UITableView *contestantTableView;

@end

@implementation ViewController

- (NSArray *)rateTitles {
    if (_rateTitles == nil) {
        _rateTitles = @[ @"1. 对演讲时间的把控",
                         @"2. 演讲内容的饱满度",
                         @"3. 形象分",
                         @"4. 听完演讲后的个人收获",
                         @"5. 对整次演讲的评分" ];
    }
    return _rateTitles;
}

- (CenterTitleCellDataModel *)submitDataModel {
    if (_submitDataModel == nil) {
        _submitDataModel = [[CenterTitleCellDataModel alloc] init];
        _submitDataModel.titleString = @"提 交";
        _submitDataModel.titleColor = [UIColor colorWithRed:249.f/255.f green:164.f/255.f blue:50.f/255.f alpha:1.f];
    }
    return _submitDataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"打  分";
    
    [self.tableView registerNib:[UINib nibWithNibName:RateCellIdentifier bundle:nil]
         forCellReuseIdentifier:RateCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CenterTitleCellIdentifier bundle:nil]
         forCellReuseIdentifier:CenterTitleCellIdentifier];
    
    // 数据源
    NSMutableArray *tempRateDataModels = [NSMutableArray array];
    for (int index = 0; index < self.rateTitles.count; index ++) {
        RateCellDataModel *tempDataModel =[[RateCellDataModel alloc] init];
        tempDataModel.titleString = self.rateTitles[index];
        tempDataModel.score = 0;

        tempDataModel.rateBlock = ^(RateTableViewCell *rateCell, NSInteger score) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:rateCell];
            RateCellDataModel *rateDataModel = self.rateDataModels[indexPath.section];
            rateDataModel.score = score;
        };
        [tempRateDataModels addObject:tempDataModel];
    }
    self.rateDataModels = [tempRateDataModels copy];
    
    // 构建展示所有参赛者的View
    self.maskImageView = [[UIImageView alloc] init];
    self.maskImageView.userInteractionEnabled = YES;
    [[AppDelegate getInstance].window addSubview:self.maskImageView];
    self.maskImageView.hidden = YES;
    
    self.contestantTableView = [[UITableView alloc] init];
    self.contestantTableView.delegate = self;
    self.contestantTableView.dataSource = self;
    [[AppDelegate getInstance].window addSubview:self.contestantTableView];
    self.contestantTableView.hidden = YES;
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([AppDelegate getInstance].window);
        make.centerY.equalTo([AppDelegate getInstance].window);
        make.width.equalTo([AppDelegate getInstance].window);
        make.height.equalTo([AppDelegate getInstance].window);
    }];
    [self.contestantTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([AppDelegate getInstance].window);
        make.centerY.equalTo([AppDelegate getInstance].window);
        make.width.equalTo(@(CGRectGetWidth([AppDelegate getInstance].window.frame) - 100));
        make.height.equalTo(@(0));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullAllContestant:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.rateDataModels.count + 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 1;
    }
    return self.contestantDataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableView) {
        if (self.rateDataModels.count > indexPath.section) {
            RateTableViewCell *rateCell =
                [self.tableView dequeueReusableCellWithIdentifier:RateCellIdentifier];
            [rateCell configureWithDataModel:self.rateDataModels[indexPath.section]];
            return rateCell;
        }
        
        CenterTitleTableViewCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:CenterTitleCellIdentifier];
        [cell configureWithDataModel:self.submitDataModel];
        return cell;
    }
    else {
        RankDataModel *dataMode = self.contestantDataModels[indexPath.row];
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = dataMode.name;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView && self.rateDataModels.count > indexPath.section) {
        return 140.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView && self.rateDataModels.count > section) {
        return 20.f;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView && self.rateDataModels.count == indexPath.section) {
        // 点击了提交按钮
        for (RateCellDataModel *rateDataModel in self.rateDataModels) {
            if (rateDataModel.score == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"🙏🏻你真的要给他打0分吗？🙏🏻"
                                                                   delegate:self
                                                          cancelButtonTitle:@"重新打分"
                                                          otherButtonTitles:@"继续提交", nil];
                [alertView show];
                return;
            }
        }
        
        if (self.contestantDataModels.count == 0) {
            [SVProgressHUD show];
            [self pullAllContestant:^{
                [self.contestantTableView reloadData];
                [self showAllContestantAndChoose];
            }];
        }
        else {
            [self.contestantTableView reloadData];
            [self showAllContestantAndChoose];
        }
    }
    else {
        [self dismissContestant:^{
            RankDataModel *dataModel = self.contestantDataModels[indexPath.row];
            [self submitRateScoreToWho:dataModel.name];
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.contestantDataModels.count == 0) {
            [SVProgressHUD show];
            [self pullAllContestant:^{
                [self.contestantTableView reloadData];
                [self showAllContestantAndChoose];
            }];
        }
        else {
            [self.contestantTableView reloadData];
            [self showAllContestantAndChoose];
        }
    }
}

- (void)pullAllContestant:(void (^)())completion {

    [[SyncHelper shareSyncHelper] pullRanksCompletion:^(NSDictionary *resultDictionary) {
        if ([resultDictionary.allKeys containsObject:@"code"]) {
            // 失败了
            NSNumber *code = resultDictionary[@"code"];
            if ([code integerValue] == 0) {
                [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
            }
        }
        else {
            // 数据Pull成功
            NSMutableArray *rankDatas = [NSMutableArray array];
            for (NSString *userName in resultDictionary.allKeys) {
                
                if ([userName isEqualToString:[AccountManager shareAccountManager].lastUserID]) {
                    // 把自己过滤掉
                    continue;
                }
                
                NSDictionary *userInfo = resultDictionary[userName];
                if ([userInfo.allKeys containsObject:@"order"]) {
                    
                    RankDataModel *tempData = [[RankDataModel alloc] init];
                    tempData.name = userName;
                    tempData.score = userInfo[@"score"];
                    tempData.order = userInfo[@"order"];
                    [rankDatas addObject:tempData];
                }
                else {
                    // 没有Order的用户是不在本次比赛中的, 不需要展示
                    continue;
                }
            }

            [rankDatas sortUsingComparator:^NSComparisonResult(RankDataModel *user1, RankDataModel *user2) {
                NSComparisonResult comparisonResult = [user2.score compare:user1.score];
                if (NSOrderedSame == comparisonResult) {
                    return [user1.order compare:user2.order];
                }
                return comparisonResult;
            }];
            self.contestantDataModels = [rankDatas copy];
            
            [SVProgressHUD dismiss];
            if (completion) {
                completion();
            }
        }
    }
                                                error:^(NSError *error){
                                                    [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                                                }];
}

- (void)showAllContestantAndChoose {
    
    self.maskImageView.image = [[UIImage screenshotCapturedWithinView:[AppDelegate getInstance].window]
                                applyBlurWithRadius:
                                12 tintColor:[UIColor colorWithRed:178.f/255.f green:181.f/255.f blue:168.f/255.f alpha:0.3f]
                                saturationDeltaFactor:1
                                maskImage:nil];
    
    self.maskImageView.alpha = 0.f;
    self.maskImageView.hidden = NO;
    self.contestantTableView.alpha = 0.f;
    self.contestantTableView.hidden = NO;
    
    CGFloat tableViewHeight = MIN(self.contestantDataModels.count * 44.f, 300.f);
    [self.contestantTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tableViewHeight));
    }];
    [[AppDelegate getInstance].window layoutSubviews];

    self.contestantTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:.3f animations:^{
        self.maskImageView.alpha = 1.f;
        self.contestantTableView.alpha = 0.8f;
        self.contestantTableView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2f animations:^{
            self.contestantTableView.alpha = 1.f;
            self.contestantTableView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

- (void)dismissContestant:(void (^)())completion {

    [UIView animateWithDuration:.3f animations:^{
        self.maskImageView.alpha = 0.f;
        self.contestantTableView.alpha = 0.f;
        self.contestantTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        self.maskImageView.hidden = YES;
        self.contestantTableView.hidden = YES;
        
        if (completion) {
            completion();
        }
    }];
}

- (void)submitRateScoreToWho:(NSString *)to {
    
    [SVProgressHUD show];
    
    NSMutableArray *scoreArray = [NSMutableArray array];
    for (RateCellDataModel *rateDataModel in self.rateDataModels) {
        // "time", "describe", "imagery", "harvest", "all"
        [scoreArray addObject:@(rateDataModel.score)];
    }
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:to forKey:@"to"];
    [postDictionary setValue:scoreArray forKey:@"skills"];
    
    [[SyncHelper shareSyncHelper] postScoreWithPostDictionary:postDictionary
                                                   completion:^(NSDictionary *resultDictionary) {
                                                       
                                                       if ([resultDictionary.allKeys containsObject:@"code"]) {
                                                           NSNumber *code = resultDictionary[@"code"];
                                                           if ([code integerValue] == 1) {
                                                               // 提交成功
                                                               [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                                                           }
                                                           else if ([code integerValue] == 2) {
                                                               // 自己给自己打分
                                                               [SVProgressHUD showErrorWithStatus:@"抱歉，自己不能给自己打分，我们是一个公平的公正公开的比赛"];
                                                           }
                                                           else {
                                                               // 提交失败
                                                               [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                                                           }
                                                       }
                                                   }
                                                        error:^(NSError *error){
                                                            [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                                                        }];
}

@end
