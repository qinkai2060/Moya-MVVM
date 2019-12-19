//
//  HMHPhoneBookDetailInfoView.m
//  housebank
//
//  Created by Qianhong Li on 2017/11/2.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHPhoneBookDetailInfoView.h"

@interface HMHPhoneBookDetailInfoView()

@property (nonatomic, strong) UIImageView *HMH_iconImage;
@property (nonatomic, strong) UILabel *HMH_nameLab;
@property (nonatomic, strong) UILabel *HMH_phoneNumLab;
@property (nonatomic,strong) UIButton *HMH_guanZhuBtn;

@end


@implementation HMHPhoneBookDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(240, 240, 244, 1);
        [self createView];
    }
    return self;
}

- (void)createView{
    //  whiteView
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 80)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //  HMH_iconImage
    self.HMH_iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.HMH_iconImage.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:self.HMH_iconImage];
    
    //  HMH_nameLab
    self.HMH_nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImage.frame) + 10, self.HMH_iconImage.frame.origin.y + 10, self.frame.size.width - CGRectGetMaxX(self.HMH_iconImage.frame) - 20, 20)];
    self.HMH_nameLab.font = [UIFont systemFontOfSize:16.0];
    self.HMH_nameLab.textColor = RGBACOLOR(97, 97, 97, 1);
    [whiteView addSubview:self.HMH_nameLab];
    
    //  HMH_phoneNumLab
    self.HMH_phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_nameLab.frame.origin.x, CGRectGetMaxY(self.HMH_nameLab.frame) + 5, self.HMH_nameLab.frame.size.width, self.HMH_nameLab.frame.size.height)];
    self.HMH_phoneNumLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_phoneNumLab.textColor = RGBACOLOR(169, 169, 169, 1);
    [whiteView addSubview:self.HMH_phoneNumLab];
    
    //  HMH_guanZhuBtn
    self.HMH_guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_guanZhuBtn.frame = CGRectMake(ScreenWidth - 20 - 80, whiteView.frame.size.height / 2 - 34 / 2, 80, 34);
    [self.HMH_guanZhuBtn setTitle:@" 关注" forState:UIControlStateNormal];
    [self.HMH_guanZhuBtn setTitle:@" 已关注" forState:UIControlStateNormal];
    [self.HMH_guanZhuBtn setImage:[UIImage imageNamed:@"chat_detail_unconcern"] forState:UIControlStateNormal];
    [self.HMH_guanZhuBtn setTitleColor:RGBACOLOR(14, 149, 219, 1) forState:UIControlStateNormal];
    [self.HMH_guanZhuBtn setTitleColor:RGBACOLOR(14, 149, 219, 1) forState:UIControlStateSelected];
    self.HMH_guanZhuBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.HMH_guanZhuBtn.backgroundColor = [UIColor whiteColor];
    [self.HMH_guanZhuBtn addTarget:self action:@selector(guanZhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.HMH_guanZhuBtn.layer.masksToBounds = YES;
    self.HMH_guanZhuBtn.layer.cornerRadius = 13;
    self.HMH_guanZhuBtn.layer.borderWidth = 1;
    self.HMH_guanZhuBtn.layer.borderColor = RGBACOLOR(14, 149, 219, 1).CGColor;
    ManagerTools *managerTools = [ManagerTools ManagerTools];
    if (managerTools.appInfoModel) {
        if (((!managerTools.appInfoModel.momentsSwitch) && (![managerTools.appInfoModel.momentsSwitch isEqualToString:@"0"])) || [managerTools.appInfoModel.momentsSwitch isEqualToString:@"1"]) { // 开关 判断是否打开 关注字段
            
            [whiteView addSubview:self.HMH_guanZhuBtn];
        }
    }
}

- (void)guanZhuBtnClick:(UIButton *)btn{
    if (self.guanZhuClick) {
        self.guanZhuClick(btn);
    }
}

- (void)reshDetailInfoViewWithModel:(HMHPersonInfoModel *)infoModel withDetailModel:(HMHPhoneBookDetailInfoModel *)detailModel{
    
    NSString *imagePathStr;
    NSString *nameStr;
    NSString *mobilePhoneStr;
    if (detailModel) {
        imagePathStr = detailModel.imagePath;
        if (detailModel.nickname.length > 0) {
            nameStr = detailModel.nickname;
        } else if (infoModel.contactName.length > 0){
            nameStr = infoModel.contactName;
        }
        mobilePhoneStr = detailModel.mobilePhone;
    } else {
        imagePathStr = infoModel.contactPic;
        if (infoModel.contactName.length > 0) {
            nameStr = infoModel.contactName;
        }
        mobilePhoneStr = infoModel.mobilePhone;
    }
    
    [self.HMH_iconImage sd_setImageWithURL:[NSURL URLWithString:imagePathStr] placeholderImage:[UIImage imageNamed:@"circle_default_icon"]];
    if (nameStr.length > 0) {
        self.HMH_nameLab.text = nameStr;
    } else {
        self.HMH_nameLab.text = @"未知";
    }
    
    self.HMH_phoneNumLab.text = mobilePhoneStr;
    
    if (detailModel.uid.length > 0) {
        self.HMH_guanZhuBtn.hidden = NO;
        
        if ([detailModel.follow isEqualToString:@"true"]) { // 已关注
            [self.HMH_guanZhuBtn setTitle:@" 已关注" forState:UIControlStateNormal];
            [self.HMH_guanZhuBtn setImage:[UIImage imageNamed:@"chat_detail_concern"] forState:UIControlStateNormal];
        } else if([detailModel.follow isEqualToString:@"false"]){ // 未关注
            [self.HMH_guanZhuBtn setTitle:@" 关注" forState:UIControlStateNormal];
            [self.HMH_guanZhuBtn setImage:[UIImage imageNamed:@"chat_detail_unconcern"] forState:UIControlStateNormal];
        }
    } else {
        self.HMH_guanZhuBtn.hidden = YES;
    }
}

@end
