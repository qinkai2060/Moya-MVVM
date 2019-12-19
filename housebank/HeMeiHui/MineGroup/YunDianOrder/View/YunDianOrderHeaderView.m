//
//  YunDianOrderHeaderView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//


#import "YunDianOrderHeaderView.h"
#import "JudgeOrderType.h"
@implementation YunDianOrderHeaderView

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
    
    self.line.frame = CGRectMake(MaxX(_typeLabel) + 10, 0, 1, 10);
    
    self.line.centerY = self.typeLabel.centerY;
    
    self.stateLabel.frame = CGRectMake(_bgView.width - [self calculateRowWidth:self.stateLabel.text] - 10, MinY(_imgLogo), [self calculateRowWidth:self.stateLabel.text], 15);
    
    float maxWeight = _bgView.width - 56 - [self calculateRowWidth:self.stateLabel.text] - 10 - 20 - typeLabelWeight;
    
    if ([JudgeOrderType yunDianTableViewIsShowJS:_orderListModel]) {
        maxWeight  = _bgView.width - 56 - [self calculateRowWidth:self.stateLabel.text] - 10 - 38 - 20 - typeLabelWeight;
        self.settleLabel.frame = CGRectMake(_bgView.width - [self calculateRowWidth:self.stateLabel.text] - 10 - 38, MinY(_imgLogo) + 1.5, 33, 12);
        if (self.state < 4) {
            //退款售后列表解算隐藏
            self.settleLabel.hidden = NO;

        }
    }
    
    
    float trueWeight = [self calculateRowWidth:self.storeNamelL.text];
    
    if (trueWeight < maxWeight) {
        self.storeNamelL.frame = CGRectMake(MaxX(_line) + 10, MinY(_imgLogo), trueWeight, 30);
    } else {
        self.storeNamelL.frame = CGRectMake(MaxX(_line) + 10, MinY(_imgLogo), maxWeight, 30);
        
    }
    self.storeNamelL.centerY = _imgLogo.centerY;
    
    self.imgNext.frame = CGRectMake(MaxX(_storeNamelL), MinY(_imgLogo), 15, 15);
    
}
- (void)setOrderListModel:(YunDianOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    
    switch ([orderListModel.shopsType integerValue]) {//1=合发购，2=OTO，3=微店
        case 1:
            self.imgLogo.image = [UIImage imageNamed:@"icon_store"];
            self.typeLabel.text = @"商城";
            break;
        case 2:
            self.imgLogo.image = [UIImage imageNamed:@"icon_sellNew"];
            self.typeLabel.text = @"云店";

            break;
        case 3:
            self.imgLogo.image = [UIImage imageNamed:@"icon_sellNew"];
            self.typeLabel.text = @"云店";

            break;
            
        default:
            break;
    }
    [self shoppingCenterOrder];

    [self setFrame];
    
}

- (void)shoppingCenterOrder{
    self.storeNamelL.text = _orderListModel.shopsName;
    
    if (CHECK_STRING_ISNULL(_orderListModel.returnState)) {
        switch ([_orderListModel.orderState integerValue]) {
            case 1:
            {
                //待付款
                self.stateLabel.text = @"待付款";
                
            }
                break;
            case 2:
            {
                //商城: 待发货 (退款, 发货)云店 _商家配送: 待配送(退款 配送) 云店 _自取: 待取货(退款 核销)   0：自提，1：快递，2：闪送，3：配送
                
                self.stateLabel.text = @"待发货";
                
                
            }
                break;
            case 3:
            {
                //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
                // 0：自提，1：快递，2：闪送，3：配送
                
                //已完成
                if ([_orderListModel.distribution isEqual:@(0)]) {
                    //自提
                    self.stateLabel.text = @"待取货";

                } else  {
                    self.stateLabel.text = @"待收货";
                }
                
            }
                break;
            case 4:
            {
                //退货中
                self.stateLabel.text = @"退款中";
            }
                break;
            case 5:
            {
                //已退货
                self.stateLabel.text = @"已退款";
            }
                break;
            case 6:
            {
                //已取消
                
                self.stateLabel.text = @"已取消";
                
            }
                break;
            case 7:
            {
                //已完成
                self.stateLabel.text = @"已完成";
                if (CHECK_STRING_ISNULL(_orderListModel.commented)) {
                    self.stateLabel.text = @"待评价";
                } else {
                    if ([_orderListModel.commented integerValue] == 1) {
                        self.stateLabel.text = @"已完成";
                    } else {
                        self.stateLabel.text = @"待评价";
                    }
                }
                
            }
                break;
            case 8:
                //已完成
            {
                self.stateLabel.text = @"已完成";
            }
                
                
                break;
            case 9:
                //已终止
            {
                self.stateLabel.text = @"已终止";
            }
                break;
            case 10:
                //已完成
                self.stateLabel.text = @"已完成";
                
                break;
                
            default:
                break;
        }
    } else {
        
        if ( [_orderListModel.returnState isEqual:@(2)]) {
            self.stateLabel.text = @"取消退款";
        }else if ( [_orderListModel.returnState isEqual:@(3)]) {
            self.stateLabel.text = @"商家拒绝";
        }else if ( [_orderListModel.returnState isEqual:@(1)]) {
            self.stateLabel.text = @"退款待处理";
        }else if ( [_orderListModel.returnState isEqual:@(4)]) {
            self.stateLabel.text = @"已退款";
        }   else if ([_orderListModel.returnState isEqual:@(5)]){
            self.stateLabel.text = @"退款待仲裁";
        }else if ([_orderListModel.returnState isEqual:@(6)]){
            self.stateLabel.text = @"拒绝退款";
        } else if ([_orderListModel.returnState isEqual:@(7)]){
            self.stateLabel.text = @"已退款";
        }  else {
            self.stateLabel.text = @"";

        }
        
    }
    
}

- (void)tapAction{
    if (self.clickHeaderBlock) {
        self.clickHeaderBlock(self.tag - 1000);
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
- (UILabel *)settleLabel{
    if (!_settleLabel) {
        _settleLabel = [[UILabel alloc] init];
        _settleLabel.font = PFR9Font;
        _settleLabel.hidden = YES;
        _settleLabel.text = @"未结算";
        _settleLabel.textColor = [UIColor whiteColor];
        _settleLabel.layer.cornerRadius = 2;
        _settleLabel.layer.masksToBounds = YES;
        _settleLabel.backgroundColor = HEXCOLOR(0xF63019);
        _settleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_settleLabel];
    }
    return _settleLabel;
}

@end
