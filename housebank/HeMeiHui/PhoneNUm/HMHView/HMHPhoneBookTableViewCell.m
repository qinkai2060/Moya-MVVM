//
//  HMHPhoneBookTableViewCell.m
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import "HMHPhoneBookTableViewCell.h"


@interface HMHPhoneBookTableViewCell ()

@property (nonatomic, strong) UILabel *HMH_nameLab;
@property (nonatomic, strong) UILabel *HMH_phoneLab;
@property (nonatomic, strong) UIImageView *HMH_iconImageView;

@property (nonatomic, strong) UIButton *HMH_topButton;

@property (nonatomic, strong) UIButton *HMH_chatButton;

@end

@implementation HMHPhoneBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createPhoneBookTableView];
    }
    
    return self;
}

- (void)HMH_createPhoneBookTableView{
    // HMH_iconImageView
    self.HMH_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    [self.contentView addSubview:self.HMH_iconImageView];
    
    // HMH_nameLab
    self.HMH_nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImageView.frame) + 10, self.HMH_iconImageView.frame.origin.y, ScreenW - CGRectGetMaxX(self.HMH_iconImageView.frame) - 20 -90 - 50, 20)];
    self.HMH_nameLab.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.HMH_nameLab];
    
    // HMH_phoneLab
    self.HMH_phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_nameLab.frame.origin.x, CGRectGetMaxY(self.HMH_nameLab.frame) + 5, self.HMH_nameLab.frame.size.width, self.HMH_nameLab.frame.size.height)];
    self.HMH_phoneLab.font = [UIFont systemFontOfSize:14];
    self.HMH_phoneLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.HMH_phoneLab];
    
    //
    self.stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateBtn.frame = CGRectMake(ScreenW - 20 - 141 / 2, 20, 141 / 2, 43 / 2);

    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = 3;
    self.stateBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:self.stateBtn];
    
    //
    self.HMH_topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_topButton.frame = CGRectMake(ScreenW - 20 - 141 / 2 , 15, 141 / 2 + 10, 43 / 2 + 10);
    self.HMH_topButton.backgroundColor = [UIColor clearColor];
    
    [self.HMH_topButton addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.HMH_topButton];
    
    //
    self.HMH_chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_chatButton.frame = CGRectMake(ScreenW - 20 - 141 / 2 - 45 , 0, 45, 30 + 30); // 27 22
    [self.HMH_chatButton setImage:[UIImage imageNamed:@"icon-lt"] forState:UIControlStateNormal];
    self.HMH_chatButton.backgroundColor = [UIColor clearColor];
    
    self.HMH_chatButton.hidden = YES;
    [self.HMH_chatButton addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.HMH_chatButton];
    
}

// 聊天按钮的点击事件
- (void)chatBtnClick:(UIButton *)btn{
//    if (self.chatBtnBlock) {
//        self.chatBtnBlock(self);
//    }
}

// 会员或门店按钮的点击事件
- (void)stateBtnClick:(UIButton *)btn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self);
    }
}

- (void)refreshTableViewCellWithInfoModel:(HMHPersonInfoModel *)model{
    
    self.HMH_iconImageView.backgroundColor = [UIColor redColor];
    [self.HMH_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.contactPic] placeholderImage:[UIImage imageNamed:@"headerImage"]];
    self.HMH_nameLab.text = model.contactName;
    self.HMH_phoneLab.text =model.mobilePhone;
    
    if ([model.inviteRole isEqual:@"1"] || (model.inviteRole.length == 0)) { // || [model.inviteRole isEqual:@"2"]  || (model.inviteRole.length == 0）
        self.stateBtn.hidden = NO;
        self.HMH_topButton.hidden = NO;
        self.stateBtn.x = ScreenW - 20 - 141 / 2;

        
        self.HMH_topButton.x = ScreenW - 20 - 141 / 2;
        
        self.HMH_chatButton.x = ScreenW - 20 - 141 / 2 - 45;
        
    } else {
        self.stateBtn.hidden = YES;
        self.HMH_topButton.hidden = YES;
        
        self.HMH_chatButton.x = ScreenW - 20 - 45;
        
    }
    
    if ([model.inviteRole isEqualToString:@"1"]) { // 会员
        [self.stateBtn setImage:[UIImage imageNamed:@"HuiYuanImage"] forState:UIControlStateNormal];
    }
//    else if ([model.inviteRole isEqualToString:@"2"]){ // 门店
//        [self.stateBtn setImage:[UIImage imageNamed:@"menDianImage"] forState:UIControlStateNormal];
//    }
    else if([model.inviteRole isEqualToString:@"3"]){
        [self.stateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
//    if ([model.contactRole isEqualToString:@"1"]||model.contactUserId.length<2) { // 表示没有注册过
//        self.HMH_chatButton.hidden = YES;
//    } else {
//        self.HMH_chatButton.hidden = NO;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
