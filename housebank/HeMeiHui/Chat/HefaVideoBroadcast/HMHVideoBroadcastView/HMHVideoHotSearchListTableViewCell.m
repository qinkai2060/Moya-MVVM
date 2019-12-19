//
//  HMHVideoHotSearchListTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoHotSearchListTableViewCell.h"

@interface HMHVideoHotSearchListTableViewCell ()

@property (nonatomic, strong) UILabel *HMH_numLab;
@property (nonatomic, strong) UILabel *HMH_contentLab;

@end

@implementation HMHVideoHotSearchListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_numLab = [[UILabel alloc] initWithFrame:CGRectMake(10,10.5,14,14)];
    self.HMH_numLab.textColor = [UIColor whiteColor];
    self.HMH_numLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_numLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.HMH_numLab];
    
    //
    self.HMH_contentLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_numLab.frame) + 10, 0, ScreenW - CGRectGetMaxX(self.HMH_numLab.frame) - 10, 35)];
    self.HMH_contentLab.font = [UIFont systemFontOfSize:15.0];
    self.HMH_contentLab.textColor = RGBACOLOR(63, 64, 65, 1);
    [self.contentView addSubview:self.HMH_contentLab];
}

- (void)refreshCellWithModel:(HMHVideoTagsModel *)model{
    if ([model.sort longLongValue] == 1) {
        self.HMH_numLab.backgroundColor = RGBACOLOR(299, 0, 24, 1);
    } else if ([model.sort longLongValue] == 2){
        self.HMH_numLab.backgroundColor = RGBACOLOR(241, 97, 27, 1);
    } else if ([model.sort longLongValue] == 3){
        self.HMH_numLab.backgroundColor = RGBACOLOR(243, 178, 26, 1);
    } else {
        self.HMH_numLab.backgroundColor = RGBACOLOR(169, 171, 172, 1);
    }
    self.HMH_numLab.text = [NSString stringWithFormat:@"%@",model.sort];

    self.HMH_contentLab.text = model.searchWord;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
