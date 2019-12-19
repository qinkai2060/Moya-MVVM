//
//  YunDianOrderDetailHeaderView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderDetailHeaderView.h"
#import "JudgeOrderType.h"
#import "ResetSecondaryPasswordView.h"//取手机号****得类方法
@implementation YunDianOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setDetailHeaderModel:(YunDianOrderListDetailModel *)detailHeaderModel{
    _detailHeaderModel = detailHeaderModel;
    _nameLabel.text = CHECK_STRING(_detailHeaderModel.orderReceiptAddress.name);
    _phoneLable.text = CHECK_STRING(_detailHeaderModel.orderReceiptAddress.phone);//[ResetSecondaryPasswordView replaceStringWithAsterisk: startLocation:3 lenght:4]
    _addressLabel.text = CHECK_STRING(_detailHeaderModel.orderReceiptAddress.completeAddress);
    [self shoppingCenterOrder];
    [self changeUi];
}
- (void)tapCopyAction{
    NSString *strCopy = [NSString stringWithFormat:@"%@ %@ %@", CHECK_STRING(_detailHeaderModel.orderReceiptAddress.name),CHECK_STRING(_detailHeaderModel.orderReceiptAddress.phone),CHECK_STRING(_detailHeaderModel.orderReceiptAddress.completeAddress)];
    if (strCopy.length) {
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        
        pastboard.string = strCopy;
        [SVProgressHUD showSuccessWithStatus:@"收货信息已复制到剪贴板!"];
        [SVProgressHUD dismissWithDelay:1];
    }
}
- (void)changeUi{
    float height = [JudgeOrderType returnYunDianDetailTableViewHeaderHeight:_detailHeaderModel];
    if (height == 70) {
        //没物流 没收获地址
        _logisticsView.hidden = YES;
        _addresseeView.hidden = YES;
        [self.logisticsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imgState.mas_bottom);
            make.height.mas_equalTo(0);
        }];
        [self.addresseeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imgState.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    } else if (height == 145){
        //无物流
        _logisticsView.hidden = YES;
        _addresseeView.hidden = NO;
        [self.logisticsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imgState.mas_bottom);
            make.height.mas_equalTo(0);
        }];
        [self.addresseeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imgState.mas_bottom);
            make.height.mas_equalTo(75);
        }];
    } else {
        //全有
        _logisticsView.hidden = NO;
        _addresseeView.hidden = NO;
        if (self.dic_wl) {
            _logisticsStateLabel.text = [self.dic_wl objectForKey:@"context"];
            _latestTimeLabel.text = [self.dic_wl objectForKey:@"time"];
        } else {
            _logisticsStateLabel.text = @"暂无物流信息!";
            _latestTimeLabel.text = @"";
        }
        
        [self.logisticsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imgState.mas_bottom);
            make.height.mas_equalTo(75);
        }];
        [self.addresseeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.logisticsView.mas_bottom);
            make.height.mas_equalTo(75);
        }];
        
    }
}
- (void)shoppingCenterOrder{
    
    
    switch ([_detailHeaderModel.orderState integerValue]) {
        case 1:
        {
            //待付款
            self.imgState.image = [UIImage imageNamed:@"icon_bg_dfk"];
        }
            break;
        case 2:
        {
            //商城: 待发货 (退款, 发货)云店 _商家配送: 待配送(退款 配送) 云店 _自取: 待取货(退款 核销)   0：自提，1：快递，2：闪送，3：配送
            self.imgState.image = [UIImage imageNamed:@"icon_bg_dfh"];
            
            
        }
            break;
        case 3:
        {
            //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
            // 0：自提，1：快递，2：闪送，3：配送
            self.imgState.image = [UIImage imageNamed:@"icon_bg_dsh"];
        }
            break;
        case 4:
        {
            //退货中
            self.imgState.image = [UIImage imageNamed:@"icon_bg_th"];
            
        }
            break;
        case 5:
        {
            //已退货
            self.imgState.image = [UIImage imageNamed:@"icon_bg_yth"];
            
        }
            break;
        case 6:
        {
            //已取消
            
            self.imgState.image = [UIImage imageNamed:@"icon_bg_yqx"];
        }
            break;
        case 7:
        {
            //已完成
            if (CHECK_STRING_ISNULL(self.commented)) {
                self.imgState.image = [UIImage imageNamed:@"icon_bg_dpj"];
                
            } else {
                    if ([self.commented integerValue] == 1) {
                        self.imgState.image = [UIImage imageNamed:@"icon_bg_ywc"];
                    } else {
                        self.imgState.image = [UIImage imageNamed:@"icon_bg_dpj"];        }
                }
            
        }
            break;
        case 8:
            //已完成待评价
        {
            self.imgState.image = [UIImage imageNamed:@"icon_bg_ywc"];
            
            
        }
            
            
            break;
        case 9:
            //已终止
        {
            self.imgState.image = [UIImage imageNamed:@"icon_bg_ywc"];
            
        }
            break;
        case 10:
            //已完成
            self.imgState.image = [UIImage imageNamed:@"icon_bg_ywc"];
            break;
            
        default:
            break;
    }
}
- (void)setUI{
    
    [self addSubview:self.imgState];
    [self addSubview:self.logisticsView];
    [self.logisticsView addSubview:self.logisticsStateLabel];
    [self.logisticsView addSubview:self.latestTimeLabel];
    [self addSubview:self.addresseeView];
    [self.addresseeView addSubview:self.nameLabel];
    [self.addresseeView addSubview:self.phoneLable];
    [self.addresseeView addSubview:self.copyLabel];
    [self.addresseeView addSubview:self.addressLabel];
    
    
    //frame
    [self.imgState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [self.logisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imgState.mas_bottom);
        make.height.mas_equalTo(75);
    }];
    
    UIImageView *logisticsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wuliu"]];
    [self.logisticsView addSubview:logisticsImg];
    [logisticsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsView).offset(20);
        make.top.equalTo(self.logisticsView).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.logisticsStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logisticsImg.mas_right).offset(10);
        make.top.equalTo(logisticsImg);
        make.right.equalTo(self.logisticsView).offset(- 40);
        make.height.mas_equalTo(20);
    }];
    
    [self.latestTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsStateLabel);
        make.top.equalTo(self.logisticsStateLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yd_arrow"]];
    [self.logisticsView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logisticsView).offset(-15);
        make.centerY.equalTo(self.logisticsView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xE5E5E5);
    [self.logisticsView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsView).offset(20);
        make.right.equalTo(self.logisticsView).offset(-20);
        make.bottom.equalTo(self.logisticsView);
        make.height.mas_equalTo(0.7);
    }];
    
    
    [self.addresseeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.logisticsView.mas_bottom);
        make.height.mas_equalTo(75);
    }];
    
    UIImageView *addressImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shaddress"]];
    [self.addresseeView addSubview:addressImg];
    [addressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addresseeView).offset(20);
        make.top.equalTo(self.addresseeView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImg.mas_right).offset(10);
        make.top.equalTo(addressImg);
        make.height.mas_equalTo(20);
    }];
    
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15);
        make.top.equalTo(addressImg);
        make.height.mas_equalTo(20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.addresseeView).offset(-76);
    }];
    [self.copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addresseeView).offset(-15);
        make.centerY.equalTo(self.addressLabel);   make.size.mas_equalTo(CGSizeMake(46, 20));
    }];
    
    
}
/**
 状态图片
 */
- (UIImageView *)imgState{
    if (!_imgState) {
        _imgState = [[UIImageView alloc] init];
        //        _imgState.image = [UIImage imageWithImageName:@"icon_bg_dfh"];
    }
    return _imgState;
}

/**
 物流试图
 */
- (UIView *)logisticsView{
    if (!_logisticsView) {
        _logisticsView = [[UIView alloc] init];
        _logisticsView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_logisticsView addGestureRecognizer:tap];
    }
    return _logisticsView;
}
- (void)tapAction{
    if ([self.delegate respondsToSelector:@selector(yunDianOrderDetailHeaderViewClickDelegateViewLogistics)]) {
        [self.delegate yunDianOrderDetailHeaderViewClickDelegateViewLogistics];
    }
}
/**
 物流状态
 */
- (UILabel *)logisticsStateLabel{
    if (!_logisticsStateLabel) {
        _logisticsStateLabel = [[UILabel alloc] init];
        //        _logisticsStateLabel.text = @"广东省中山市古镇岗南工业区公司...";
        _logisticsStateLabel.font = [UIFont boldSystemFontOfSize:14];
        _logisticsStateLabel.textColor = HEXCOLOR(0x333333);
        _logisticsStateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _logisticsStateLabel;
    
}

/**
 最新的物流时间
 */
- (UILabel *)latestTimeLabel{
    if (!_latestTimeLabel) {
        _latestTimeLabel = [[UILabel alloc] init];
        //        _latestTimeLabel.text = @"2018-08-11 12:04:27";
        _latestTimeLabel.font = PFR12Font;
        _latestTimeLabel.textColor = HEXCOLOR(0x666666);
        _latestTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _latestTimeLabel;
    
}
/**
 收件人信息试图
 */
- (UIView *)addresseeView{
    if (!_addresseeView) {
        _addresseeView = [[UIView alloc] init];
        _addresseeView.backgroundColor = [UIColor whiteColor];
    }
    return _addresseeView;
}

/**
 姓名
 */
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        //        _nameLabel.text = @"宋宇";
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
/**
 收件电话
 */
- (UILabel *)phoneLable{
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] init];
        //        _phoneLable.text = @"13614597056";
        _phoneLable.font = [UIFont boldSystemFontOfSize:14];
        _phoneLable.textColor = HEXCOLOR(0x333333);
        _phoneLable.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLable;
}
/**
 收件地址
 */
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        //        _addressLabel.text = @"上海市宝山区松南镇逸仙路2816号";
        _addressLabel.font = PFR12Font;
        _addressLabel.numberOfLines = 2;
        _addressLabel.textColor = HEXCOLOR(0x666666);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}
- (UILabel *)copyLabel{
    if (!_copyLabel) {
        _copyLabel = [[UILabel alloc] init];
        _copyLabel.text = @"复制";
        _copyLabel.font = [UIFont systemFontOfSize:13];
        _copyLabel.textColor = HEXCOLOR(0x666666);
        _copyLabel.textAlignment = NSTextAlignmentCenter;
        _copyLabel.layer.cornerRadius = 10;
        _copyLabel.userInteractionEnabled = YES;
        _copyLabel.layer.borderWidth = 0.5;
        _copyLabel.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        
        UITapGestureRecognizer *tapCopy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCopyAction)];
        [_copyLabel addGestureRecognizer:tapCopy];
    }
    return _copyLabel;
}

@end
