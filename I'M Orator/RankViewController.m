//
//  RankViewController.m
//  I'M Orator
//
//  Created by Wind on 15/10/31.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import "RankViewController.h"

#import "RankInfoTableViewCell.h"

#import "SVProgressHUD.h"
#import "SyncHelper.h"

#import "RankDataModel.h"

@interface RankViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *rankDataModels;

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"排  名";
    
    [self.tableView registerNib:[UINib nibWithNibName:RankInfoCellIdentifier bundle:nil]
         forCellReuseIdentifier:RankInfoCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0, 0, 0);

    // 测试数据
//    NSMutableArray *testDatas = [NSMutableArray array];
//    for (int index = 0; index < 20; index ++) {
//        RankInfoDataModel *tempData = [[RankInfoDataModel alloc] init];
//        tempData.name = [NSString stringWithFormat:@"张三%d", index];
//        
//        CGFloat score = arc4random() % 100;
//        tempData.score = @(score);
//        
//        [testDatas addObject:tempData];
//    }
//    self.rankDataModels = [testDatas copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.rankDataModels == nil) {
        [self pullRanksFromServerWithAnimation:YES];
    }
    else {
        [self pullRanksFromServerWithAnimation:NO];
    }
}

- (void)pullRanksFromServerWithAnimation:(BOOL)animation {
    if (animation) {
        [SVProgressHUD show];
    }
    [[SyncHelper shareSyncHelper] pullRanksCompletion:^(NSDictionary *resultDictionary) {
        if ([resultDictionary.allKeys containsObject:@"code"]) {
            // 失败了
            NSNumber *code = resultDictionary[@"code"];
            if ([code integerValue] == 0) {
                if (animation) {
                    [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                }
            }
        }
        else {
            if (animation) {
                [SVProgressHUD dismiss];
            }
            // 数据Pull成功
            NSMutableArray *rankDatas = [NSMutableArray array];
            for (NSString *userName in resultDictionary.allKeys) {

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
            self.rankDataModels = [rankDatas copy];
            [self.tableView reloadData];
        }
    }
                                                error:^(NSError *error){
                                                    if (animation) {
                                                        [SVProgressHUD showErrorWithStatus:@"网络状态不佳，请稍后再试"];
                                                    }
                                                }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankDataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankInfoTableViewCell *rankCell = [self.tableView dequeueReusableCellWithIdentifier:RankInfoCellIdentifier];
    
    RankDataModel *dataModel = self.rankDataModels[indexPath.row];
    rankCell.orderLabel.text = [NSString stringWithFormat:@"%@", dataModel.order];
    rankCell.nameLabel.text = dataModel.name;
    rankCell.scoreLabel.text = [dataModel.score integerValue] == 0
        ? @"-"
        : [NSString stringWithFormat:@"%@", dataModel.score];
    rankCell.separatorView.hidden = indexPath.row + 1 == self.rankDataModels.count;
    return rankCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
