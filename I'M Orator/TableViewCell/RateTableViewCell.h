//
//  RateTableViewCell.h
//  I'M Orator
//
//  Created by Wind on 15/11/1.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const RateCellIdentifier = @"RateTableViewCell";

@class RateTableViewCell;
typedef void (^RateButtonClickedBlock)(RateTableViewCell *rateCell, NSInteger score);

@interface RateCellDataModel : NSObject

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) RateButtonClickedBlock rateBlock;

@end

@interface RateTableViewCell : UITableViewCell

- (void)configureWithDataModel:(RateCellDataModel *)dataModel;

@end
