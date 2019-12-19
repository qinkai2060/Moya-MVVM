//
//  HMHShortVideoSubscribeTableViewCell.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/8.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHShortVideoSubscribeTableViewCell.h"

@interface HMHShortVideoSubscribeTableViewCell ()

@property (nonatomic, strong) UIImageView *HMH_iconImage;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_subLab;
@property (nonatomic, strong) UILabel *HMH_subscribeNumLab;
@property (nonatomic, strong) UILabel *HMH_contentNumLab;
@property (nonatomic, strong) UIButton *HMH_subscribeBtn;

@end

@implementation HMHShortVideoSubscribeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.HMH_iconImage.layer.masksToBounds = YES;
    self.HMH_iconImage.layer.cornerRadius = 5;
    [self.contentView addSubview:self.HMH_iconImage];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImage.frame) + 5, self.HMH_iconImage.frame.origin.y - 10, ScreenW - CGRectGetMaxX(self.HMH_iconImage.frame) - 10, 20)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_titleLab.textColor = RGBACOLOR(112, 112, 112, 1);
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_subLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame), self.HMH_titleLab.frame.size.width, 20)];
    self.HMH_subLab.textColor = RGBACOLOR(133, 133, 133, 1);
    self.HMH_subLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.HMH_subLab];
    
    //
    self.HMH_subscribeNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.HMH_subLab.frame), 200, 15)];
    self.HMH_subscribeNumLab.textColor = RGBACOLOR(188, 188, 188, 1);
    self.HMH_subscribeNumLab.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.HMH_subscribeNumLab];
    
    //
    self.HMH_contentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_subscribeNumLab.frame) + 5, self.HMH_subscribeNumLab.origin.y, 200, self.HMH_subscribeNumLab.frame.size.height)];
    self.HMH_contentNumLab.textColor = RGBACOLOR(188, 188, 188, 1);
    self.HMH_contentNumLab.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.HMH_contentNumLab];
    
    //
    self.HMH_subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_subscribeBtn.frame = CGRectMake(ScreenW - 10 - 45, self.frame.size.height / 2 - 10, 45, 20);
    self.HMH_subscribeBtn.backgroundColor = RGBACOLOR(55, 153, 241, 1);
    [self.HMH_subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
    self.HMH_subscribeBtn.layer.masksToBounds = YES;
    self.HMH_subscribeBtn.layer.cornerRadius = 4.0;
    [self.contentView addSubview:self.HMH_subscribeBtn];
}

- (void)refreshCellWithModel:(id)model{
    self.HMH_iconImage.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    self.HMH_titleLab.text = @"每日合发精选";
    self.HMH_subLab.text = @"每天多一点好想法";
    self.HMH_subscribeNumLab.text = @"223万人订阅";
    self.HMH_contentNumLab.text = @"198条内容";
}

@end
