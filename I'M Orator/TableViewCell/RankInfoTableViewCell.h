//
//  RankInfoTableViewCell.h
//  I'M Orator
//
//  Created by Wind on 15/11/1.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const RankInfoCellIdentifier = @"RankInfoTableViewCell";

@interface RankInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
