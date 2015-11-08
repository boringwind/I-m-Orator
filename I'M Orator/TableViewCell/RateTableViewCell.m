//
//  RateTableViewCell.m
//  I'M Orator
//
//  Created by Wind on 15/11/1.
//  Copyright © 2015年 Wind. All rights reserved.
//

#import "RateTableViewCell.h"

@implementation RateCellDataModel

@end

@interface RateTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthStarImageView;

@property (nonatomic, copy) RateButtonClickedBlock rateBlock;

@end

@implementation RateTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self refreshContentsWithScore:0];
}

- (void)refreshContentsWithScore:(NSInteger)score {
    
    UIImage *emptyStarImage = [UIImage imageNamed:@"empty_star_icon"];
    UIImage *halfStarImage = [UIImage imageNamed:@"half_star_icon"];
    UIImage *fullStarImage = [UIImage imageNamed:@"full_star_icon"];

    if (score == 0) {
        self.firstStarImageView.image = emptyStarImage;
        self.secondStarImageView.image = emptyStarImage;
        self.thirdStarImageView.image = emptyStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 1) {
        self.firstStarImageView.image = halfStarImage;
        self.secondStarImageView.image = emptyStarImage;
        self.thirdStarImageView.image = emptyStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 2) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = emptyStarImage;
        self.thirdStarImageView.image = emptyStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 3) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = halfStarImage;
        self.thirdStarImageView.image = emptyStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 4) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = emptyStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 5) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = halfStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 6) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = fullStarImage;
        self.fourthStarImageView.image = emptyStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 7) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = fullStarImage;
        self.fourthStarImageView.image = halfStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 8) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = fullStarImage;
        self.fourthStarImageView.image = fullStarImage;
        self.fifthStarImageView.image = emptyStarImage;
    }
    else if (score == 9) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = fullStarImage;
        self.fourthStarImageView.image = fullStarImage;
        self.fifthStarImageView.image = halfStarImage;
    }
    else if (score == 10) {
        self.firstStarImageView.image = fullStarImage;
        self.secondStarImageView.image = fullStarImage;
        self.thirdStarImageView.image = fullStarImage;
        self.fourthStarImageView.image = fullStarImage;
        self.fifthStarImageView.image = fullStarImage;
    }
}

- (void)configureWithDataModel:(RateCellDataModel *)dataModel {
    self.titleLabel.text = dataModel.titleString;
    [self refreshContentsWithScore:dataModel.score];

    self.rateBlock = dataModel.rateBlock;
}

- (IBAction)scoreButtonClicked:(id)sender {
    UIButton *scoreButton = (UIButton *)sender;
    [self refreshContentsWithScore:scoreButton.tag];

    if (self.rateBlock) {
        self.rateBlock(self, scoreButton.tag);
    }
}

@end
