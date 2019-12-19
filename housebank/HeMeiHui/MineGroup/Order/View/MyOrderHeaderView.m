//
//  MyOrderHeaderView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderHeaderView.h"
#import "JudgeOrderType.h"
@implementation MyOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    
    [self addSubview:self.bgView];
    [self setFrame];
}
- (void)setFrame{
    self.imgLogo.frame = CGRectMake(15, 13, 15, 15);
    
    float typeLabelWeight = [self calculateRowWidth:self.typeLabel.text];
    
    self.typeLabel.frame = CGRectMake(MaxX(_imgLogo) + 5, MinY(_imgLogo), typeLabelWeight, 15);
    
    self.line.frame = CGRectMake(MaxX(_typeLabel) + 10,0, 1, 10);
    
    self.line.centerY = self.typeLabel.centerY;
    
    self.stateLabel.frame = CGRectMake(_bgView.width - 46, MinY(_imgLogo), 36, 15);
    
    float maxWeight = _bgView.width - 56 - 46 - 20 - typeLabelWeight;
    
    float trueWeight = [self calculateRowWidth:self.storeNamelL.text];
    
    if (trueWeight < maxWeight) {
        self.storeNamelL.frame = CGRectMake(MaxX(_line) + 10, MinY(_imgLogo), trueWeight, 30);
    } else {
        self.storeNamelL.frame = CGRectMake(MaxX(_line) + 10, MinY(_imgLogo), maxWeight, 30);
        
    }
    self.storeNamelL.centerY = _imgLogo.centerY;
    
    self.imgNext.frame = CGRectMake(MaxX(_storeNamelL), MinY(_imgLogo), 15, 15);
    
}
- (void)setInfoListModel:(OrderInfoListModel *)infoListModel{
    _infoListModel = infoListModel;
    
    if ([JudgeOrderType judgeStoreOrderType:infoListModel.orderBizCategory]) {
        //商城订单
        self.imgLogo.image = [UIImage imageNamed:@"icon_store"];
        self.typeLabel.text = @"商城";
        [self noGlobalHomeOrder];
    } else if ([JudgeOrderType judgeOTOOrderType:infoListModel.orderBizCategory]){
        //云店 - oto新零售
        self.imgLogo.image = [UIImage imageNamed:@"icon_sellNew"];
        self.typeLabel.text = @"云店";
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judgeCloudOrderType:infoListModel.orderBizCategory]){
        //云店
        self.imgLogo.image = [UIImage imageNamed:@"icon_sellNew"];
        self.typeLabel.text = @"云店";
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judgeGlobalHomeOrderType:infoListModel.orderBizCategory]){
        //全球家
        self.imgLogo.image = [UIImage imageNamed:@"icon_worldHome"];
        self.typeLabel.text = @"全球家";
        [self globalHomeOrder];
        
    } else if ([JudgeOrderType judgeDelegateOrderType:infoListModel.orderBizCategory]){
        //代理
        self.imgLogo.image = [UIImage imageNamed:@"icon_delegateOrder"];
        self.typeLabel.text = @"代理订单";
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judgeWelfareOrderType:infoListModel.orderBizCategory]){
        //福利
        self.imgLogo.image = [UIImage imageNamed:@"icon_well_beingOrder"];
        self.typeLabel.text = @"福利订单";
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judge_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        self.imgLogo.image = [UIImage imageNamed:@"icon_RM"];
        self.typeLabel.text = @"注册RM";
        [self noGlobalHomeOrder];
        
    }else if ([JudgeOrderType judge_D_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        self.imgLogo.image = [UIImage imageNamed:@"icon_RM"];
        self.typeLabel.text = @"代注册RM";
        [self noGlobalHomeOrder];
        
    }else if ([JudgeOrderType judge_S_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        self.imgLogo.image = [UIImage imageNamed:@"icon_RM"];
        self.typeLabel.text = @"升级RM";
        [self noGlobalHomeOrder];
        
    }
    
    [self setFrame];
}
//非全球家订单 //<!-- 1待支付 2待发货 3待收货 4退货中 5已退货 6已取消 7已完成 8已分润 9已终止 10已评价 -->

- (void)noGlobalHomeOrder{
    self.storeNamelL.text = _infoListModel.shopsName;
    
    switch ([_infoListModel.orderState integerValue]) {
        case 1:
        {
            self.stateLabel.text = @"待付款";
        }
            break;
        case 2:
        {
            self.stateLabel.text = @"待发货";
        }
            break;
        case 3:
        {
            self.stateLabel.text = @"待收货";
        }
            break;
        case 4:
        {
            self.stateLabel.text = @"退款中";
        }
            break;
        case 5:
        {
            self.stateLabel.text = @"已退款";
        }
            break;
        case 6:
        {
            self.stateLabel.text = @"已取消";
        }
            break;
        case 7:
        {
            
            if (CHECK_STRING_ISNULL(_infoListModel.commented)) {
                self.stateLabel.text = @"待评价";
            } else {
                if ([_infoListModel.commented integerValue] == 1) {
                    self.stateLabel.text = @"已完成";
                } else {
                    self.stateLabel.text = @"待评价";
                }
            }
        }
            break;
        case 8:
        {
         self.stateLabel.text = @"已完成";
        }
            break;
            
            
        default:
            break;
    }
}
//全球家订单
- (void)globalHomeOrder{
    self.storeNamelL.text = _infoListModel.hotelTitle;
    
    switch ([_infoListModel.orderState integerValue]) {
        case 0:
        {
            self.stateLabel.text = @"待支付";
        }
            break;
        case 1:
        {
            self.stateLabel.text = @"待入住";
        }
            break;
        case 2:
        {
            self.stateLabel.text = @"待评价";
        }
            break;
        case 3:
        {
            self.stateLabel.text = @"已完成";
        }
            break;
        case 4:
        {
            self.stateLabel.text = @"已取消";
        }
            break;
        case 5:
        {
            self.stateLabel.text = @"退订中";
        }
            break;
        case 6:
        {
            self.stateLabel.text = @"已退订";
        }
            break;
        case 7:
        {
            self.stateLabel.text = @"已失效";
        }
        case 8:
        {
            self.stateLabel.text = @"支付中";
        }
        case 9:
        {
            self.stateLabel.text = @"待确认";
        }
            break;
            
        default:
            break;
    }
}
- (void)tapAction{
    if (self.clickBlock) {
        self.clickBlock(self.tag - 1000);
    }
}
- (CGFloat)calculateRowWidth:(NSString *)string {
     NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
    CGRect rect =[string boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
    
     }

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 40)];
        _bgView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _bgView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}
- (UIImageView *)imgLogo{
    if (!_imgLogo) {
        _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store"]];
        [self.bgView addSubview:_imgLogo];
        
    }
    return _imgLogo;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"代注册RM";
        _typeLabel.font = PFR12Font;
        _typeLabel.textColor = HEXCOLOR(0x333333);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_typeLabel];
    }
    return _typeLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = HEXCOLOR(0xDDDDDD);
        [self.bgView addSubview:_line];
    }
    return _line;
}
- (UILabel *)storeNamelL{
    if (!_storeNamelL) {
        _storeNamelL = [[UILabel alloc] init];
        _storeNamelL.text = @"";
        _storeNamelL.font = [UIFont boldSystemFontOfSize:12];
        _storeNamelL.textColor = HEXCOLOR(0x333333);
        _storeNamelL.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:_storeNamelL];
        _storeNamelL.userInteractionEnabled = YES;
        [_storeNamelL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
    return _storeNamelL;
}
- (UIImageView *)imgNext{
    if (!_imgNext) {
        _imgNext = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right>"]];
        [self.bgView addSubview:_imgNext];
        _imgNext.userInteractionEnabled = YES;
        _imgNext.userInteractionEnabled = YES;
        [_imgNext addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
    return _imgNext;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = PFR12Font;
        _stateLabel.textColor = HEXCOLOR(0xF3344A);
        _stateLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:_stateLabel];
    }
    return _stateLabel;
}

@end
