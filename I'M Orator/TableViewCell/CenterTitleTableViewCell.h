//
//  CenterTitleTableViewCell.h
//  TickTick
//
//  Created by Wind on 15/7/20.
//  Copyright (c) 2015年 Appest. All rights reserved.
//
//  UI 已适配
//

#import <UIKit/UIKit.h>

static NSString *const CenterTitleCellIdentifier = @"CenterTitleTableViewCell";

/** \brief CenterTitleCellDataModel<br>
 Help custom FullTitleTableViewCell's style.<br>
 <br>
 NSString *titleString<br>
 <br>
 UIColor *titleColor<br>
 -- Default value is Color_868A95<br>
 <br>
 BOOL separatorHidden<br>
 -- Default value is YES<br>
 <br>
 CGFloat separatorLeading<br>
 -- Default value is 17<br>
 <br>
 CGFloat separatorTrailing<br>
 -- Default value is 17<br>
 */
@interface CenterTitleCellDataModel : NSObject

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) BOOL separatorHidden;
@property (nonatomic, assign) CGFloat separatorLeading;
@property (nonatomic, assign) CGFloat separatorTrailing;

@end

@interface CenterTitleTableViewCell : UITableViewCell

- (void)configureWithDataModel:(CenterTitleCellDataModel *)dataModel;

@end
