//
//  HFTotalInfoView.m
//  housebank
//
//  Created by usermac on 2018/12/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTotalInfoView.h"
@interface HFTotalInfoView ()
@property(nonatomic,strong)UILabel *ordertotalPricelb;

@property(nonatomic,strong)UILabel *ordertitlelb;
@property(nonatomic,strong)UILabel *orderValuelb;

@property(nonatomic,strong)UILabel *receiveGoodstitlelb;
@property(nonatomic,strong)UILabel *receiveGoodsValuelb;

@property(nonatomic,strong)UILabel *receiveAdresstitlelb;
@property(nonatomic,strong)UILabel *rreceiveAdressValuelb;

@property(nonatomic,strong)UILabel *totalPricetitlelb;
@property(nonatomic,strong)UILabel *totalPriceValuelb;

@property(nonatomic,strong)UILabel *shoppingTimetitlelb;
@property(nonatomic,strong)UILabel *shoppingTimeValuelb;

@end
@implementation HFTotalInfoView

- (void)hh_setupViews {
    [self addSubview:self.ordertotalPricelb];
    [self addSubview:self.ordertitlelb];
    [self addSubview:self.orderValuelb];
    [self addSubview:self.receiveGoodstitlelb];
    [self addSubview:self.receiveGoodsValuelb];
    [self addSubview:self.receiveAdresstitlelb];
    [self addSubview:self.rreceiveAdressValuelb];
    [self addSubview:self.totalPricetitlelb];
    [self addSubview:self.totalPriceValuelb];
    [self addSubview:self.shoppingTimetitlelb];
    [self addSubview:self.shoppingTimeValuelb];
}
- (void)hh_bindViewModel {
    self.orderValuelb.text = @"9070482750348";
    self.rreceiveAdressValuelb.text = @"广东省广州市从化金融街";
    self.receiveGoodsValuelb.text = @"丽丽 18747638293";
    self.totalPriceValuelb.text = @"￥89.00";
    self.shoppingTimeValuelb.text = @"2018-9-10";
    self.ordertotalPricelb.text = @"¥89.00";
}
- (UILabel *)ordertitlelb {
    if (!_ordertitlelb) {
        _ordertitlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.ordertotalPricelb.bottom, 70, 15)];
        _ordertitlelb.font = [UIFont systemFontOfSize:14];
        _ordertitlelb.textColor = [UIColor blackColor];
        _ordertitlelb.text = @"订 单 号 :";
    }
    return _ordertitlelb;
}
- (UILabel *)orderValuelb {
    if (!_orderValuelb) {
        _orderValuelb = [[UILabel alloc] initWithFrame:CGRectMake(self.ordertitlelb.right+10, self.ordertotalPricelb.bottom, ScreenW-(self.ordertitlelb.right+10), 15)];
        _orderValuelb.font = [UIFont systemFontOfSize:14];
        _orderValuelb.textColor = [UIColor blackColor];
    }
    return _orderValuelb;
}
- (UILabel *)receiveGoodstitlelb {
    if (!_receiveGoodstitlelb) {
        _receiveGoodstitlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.ordertitlelb.bottom+15, 70, 15)];
        _receiveGoodstitlelb.font = [UIFont systemFontOfSize:14];
        _receiveGoodstitlelb.textColor = [UIColor blackColor];
        _receiveGoodstitlelb.text = @"收 货 人 :";
    }
    return _receiveGoodstitlelb;
}
- (UILabel *)receiveGoodsValuelb {
    if (!_receiveGoodsValuelb) {
        _receiveGoodsValuelb = [[UILabel alloc] initWithFrame:CGRectMake(self.receiveGoodstitlelb.right+10, self.ordertitlelb.bottom, ScreenW-(self.receiveGoodstitlelb.right+10), 15)];
        _receiveGoodsValuelb.font = [UIFont systemFontOfSize:14];
        _receiveGoodsValuelb.textColor = [UIColor blackColor];
    }
    return _receiveGoodsValuelb;
}
- (UILabel *)receiveAdresstitlelb {
    if (!_receiveAdresstitlelb) {
        _receiveAdresstitlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.receiveGoodstitlelb.bottom+15, 70, 15)];
        _receiveAdresstitlelb.font = [UIFont systemFontOfSize:14];
        _receiveAdresstitlelb.textColor = [UIColor blackColor];
        _receiveGoodstitlelb.text = @"收货地址 :";
    }
    return _receiveGoodstitlelb;
}
- (UILabel *)rreceiveAdressValuelb {
    if (!_rreceiveAdressValuelb) {
        _rreceiveAdressValuelb = [[UILabel alloc] initWithFrame:CGRectMake(self.receiveAdresstitlelb.right+10, self.ordertitlelb.bottom, ScreenW-(self.receiveAdresstitlelb.right+10), 15)];
        _rreceiveAdressValuelb.font = [UIFont systemFontOfSize:14];
        _rreceiveAdressValuelb.textColor = [UIColor blackColor];
    }
    return _rreceiveAdressValuelb;
}
- (UILabel *)totalPricetitlelb {
    if (!_totalPricetitlelb) {
        _totalPricetitlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.receiveAdresstitlelb.bottom+15, 70, 15)];
        _totalPricetitlelb.font = [UIFont systemFontOfSize:14];
        _totalPricetitlelb.textColor = [UIColor blackColor];
        _totalPricetitlelb.text = @"订单总价 :";
    }
    return _totalPricetitlelb;
}

- (UILabel *)totalPriceValuelb {
    if (!_totalPriceValuelb) {
        _totalPriceValuelb = [[UILabel alloc] initWithFrame:CGRectMake(self.totalPricetitlelb.right+10, ScreenW-(self.totalPricetitlelb.right+10), 70, 15)];
        _totalPriceValuelb.font = [UIFont systemFontOfSize:14];
        _totalPriceValuelb.textColor = [UIColor blackColor];
    
    }
    return _totalPriceValuelb;
}
- (UILabel *)shoppingTimetitlelb {
    if (!_shoppingTimetitlelb) {
        _shoppingTimetitlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.totalPricetitlelb.bottom+15, 70, 15)];
        _shoppingTimetitlelb.font = [UIFont systemFontOfSize:14];
        _shoppingTimetitlelb.textColor = [UIColor blackColor];
        _shoppingTimetitlelb.text = @"下单时间 :";
    }
    return _shoppingTimetitlelb;
}
- (UILabel *)shoppingTimeValuelb {
    if (!_shoppingTimeValuelb) {
        _shoppingTimeValuelb = [[UILabel alloc] initWithFrame:CGRectMake(self.shoppingTimetitlelb.right+10, ScreenW-(self.shoppingTimetitlelb.right+10), 70, 15)];
        _shoppingTimeValuelb.font = [UIFont systemFontOfSize:14];
        _shoppingTimeValuelb.textColor = [UIColor blackColor];
        
    }
    return _shoppingTimeValuelb;
}
- (UILabel *)ordertotalPricelb {
    if (!_ordertotalPricelb) {
        _ordertotalPricelb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
        _ordertotalPricelb.textAlignment = NSTextAlignmentCenter;
        _ordertotalPricelb.font = [UIFont boldSystemFontOfSize:30];
        _ordertotalPricelb.textColor = [UIColor blackColor];
    }
    return _ordertotalPricelb;
}
@end
