//
//  CenterTitleTableViewCell.m
//  TickTick
//
//  Created by Wind on 15/7/20.
//  Copyright (c) 2015年 Appest. All rights reserved.
//

#import "CenterTitleTableViewCell.h"

@implementation CenterTitleCellDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.separatorHidden = YES;
        self.separatorLeading = 17.f;
        self.separatorTrailing = 17.f;
    }
    return self;
}

@end

@interface CenterTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorTrailingConstraint;

@end

@implementation CenterTitleTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.text = nil;
}

- (void)configureWithDataModel:(CenterTitleCellDataModel *)dataModel
{
    self.titleLabel.text = dataModel.titleString;
    self.titleLabel.textColor = dataModel.titleColor;
    
    self.separatorView.hidden = dataModel.separatorHidden;
    self.separatorLeadingConstraint.constant = dataModel.separatorLeading;
    self.separatorTrailingConstraint.constant = dataModel.separatorTrailing;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.contentView.backgroundColor = backgroundColor;
    self.titleLabel.backgroundColor = backgroundColor;
}

@end
