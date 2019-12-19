//
//  HFFinalPriceView.m
//  housebank
//
//  Created by usermac on 2018/11/1.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFFinalPriceView.h"
#import "HFTextCovertImage.h"
#import "HFCarViewModel.h"
@interface HFFinalPriceView ()
@property (nonatomic,strong) CALayer *customlayer;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UILabel *allOrNoneSelectLb;
@property (nonatomic,strong) UIButton *paymentBtn;
@property (nonatomic,strong) UIButton *moveFavriteBtn;
@property (nonatomic,strong) UIButton *deletBtn;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *hejiLb;
@property (nonatomic,strong) HFCarViewModel *viewModel;
@property (nonatomic,assign) CGFloat nowprice;
@property (nonatomic,strong) CAGradientLayer *gratlayer;
//@property (nonatomic,strong) CAGradientLayer *gratlayerJiesuan;
@end
@implementation HFFinalPriceView

- (instancetype)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_bindViewModel {
    // 
    @weakify(self);
    [self.viewModel.getCarInfo subscribeNext:^(id  _Nullable x) {
        @strongify(self);
    }];
}
- (void)hh_setupViews {
    [self.layer addSublayer:self.customlayer];
    [self addSubview:self.selectBtn];
    [self addSubview:self.allOrNoneSelectLb];
//    [self.layer addSublayer:self.gratlayerJiesuan];
//    self.gratlayerJiesuan.frame = CGRectMake(ScreenW-85, 0, 85, 50);
    [self addSubview:self.paymentBtn];
    [self.layer addSublayer:self.gratlayer];
    self.gratlayer.frame = CGRectMake(ScreenW-15-80, (50-25)*0.5, 80, 25);
    [self addSubview:self.deletBtn];
    [self addSubview:self.moveFavriteBtn];
    [self addSubview:self.priceLb];
    [self addSubview:self.hejiLb];

    

    [self isEditing:NO];
}
- (void)isEditing:(BOOL)isEditing {
    self.moveFavriteBtn.hidden = !isEditing;
    self.deletBtn.hidden = !isEditing;
    self.paymentBtn.hidden = isEditing;
    //self.gratlayerJiesuan.hidden = !isEditing;
    self.priceLb.hidden = isEditing;
    self.hejiLb.hidden = isEditing;
    self.gratlayer.hidden = !isEditing;
}
- (void)isSelected:(BOOL)isSelected isEnabled:(BOOL)isEnabled {
    self.selectBtn.selected = isSelected;
    self.paymentBtn.enabled = isEnabled;
    self.paymentBtn.backgroundColor = isEnabled ?[UIColor colorWithHexString:@"FF0000"]:[UIColor colorWithHexString:@"999999"];

   // self.gratlayerJiesuan.hidden = !isEnabled;

    self.allOrNoneSelectLb.text = isSelected == NO ?@"全选":@"全不选";
}
- (void)selectClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.allOrNoneSelectLb.text = @"全不选";
    }else {
        self.allOrNoneSelectLb.text = @"全选";
    }
    [self.viewModel.allSelectSubjc sendNext:self.allOrNoneSelectLb.text];
}
- (void)clearState:(BOOL)editing{
    if (editing) {
        self.selectBtn.selected = NO;
    }
}
- (void)payMentClick :(UIButton*)btn {
    if (self.didPayBlock) {
        self.didPayBlock();
    }
}
- (void)deleteClick {
    [self.viewModel.deleteSubjc sendNext:nil];
}
- (void)moveClick {
    [self.viewModel.favSubjc sendNext:nil];
}
- (CGFloat)nowPrice {
    return self.nowprice;
}
- (void)setPrice:(CGFloat)price {
    self.nowprice = price;
    self.priceLb.attributedText = [HFTextCovertImage exchangeCommonString: [NSString stringWithFormat:@"¥%.2f",price]];
    CGFloat maxFlotPrice = self.paymentBtn.left - self.allOrNoneSelectLb.right-25-10;
    CGSize size =  [self.priceLb sizeThatFits:CGSizeMake(maxFlotPrice, 38)];
    self.priceLb.frame = CGRectMake(self.paymentBtn.left-10-size.width, 17, size.width, size.height);
    self.hejiLb.frame = CGRectMake(self.priceLb.left-28, 22, 28, 15);
}
- (UILabel *)hejiLb {
    if (!_hejiLb) {
        _hejiLb = [[UILabel alloc] init];
        _hejiLb.text = @"合计";
        _hejiLb.textColor = [UIColor colorWithHexString:@"333333"];
        _hejiLb.font = [UIFont systemFontOfSize:12];
        
    }
    return _hejiLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.textColor = [UIColor colorWithHexString:@"333333"];
        _priceLb.font = [UIFont systemFontOfSize:12];
    }
    return _priceLb;
}

- (CALayer *)customlayer {
    if (!_customlayer) {
        _customlayer = [CALayer layer];
        _customlayer.frame = CGRectMake(0, 0, ScreenW, 0.5);
        _customlayer.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        
    }
    return _customlayer;
}
- (UIButton *)moveFavriteBtn {
    if (!_moveFavriteBtn) {
        _moveFavriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.deletBtn.left-15-80, (50-25)*0.5, 80, 25)];
        _moveFavriteBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [_moveFavriteBtn setTitle:@"移入收藏" forState:UIControlStateNormal];
        _moveFavriteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moveFavriteBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _moveFavriteBtn.layer.borderWidth = 1;
        _moveFavriteBtn.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
        _moveFavriteBtn.layer.cornerRadius = 13;
        _moveFavriteBtn.layer.masksToBounds = YES;
        [_moveFavriteBtn addTarget:self action:@selector(moveClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moveFavriteBtn;
}
- (UIButton *)deletBtn {
    if (!_deletBtn) {
        _deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-15-80, (50-25)*0.5, 80, 25)];
        _deletBtn.backgroundColor = [UIColor clearColor];
        [_deletBtn setTitle:@"删除商品" forState:UIControlStateNormal];
        _deletBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deletBtn.layer.cornerRadius = 13;
        _deletBtn.layer.masksToBounds = YES;
         [_deletBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return _deletBtn;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (50-40)*0.5, 40, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [_selectBtn setImage:[UIImage imageNamed:@"car_disable_icon"] forState:UIControlStateDisabled];
        [_selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UILabel *)allOrNoneSelectLb {
    if (!_allOrNoneSelectLb) {
        _allOrNoneSelectLb = [[UILabel alloc] initWithFrame:CGRectMake(self.selectBtn.right, (50-15)*0.5, 50, 15)];
        _allOrNoneSelectLb.font = [UIFont systemFontOfSize:15];
        _allOrNoneSelectLb.textColor = [UIColor colorWithHexString:@"4C4C4C"];
        _allOrNoneSelectLb.text = @"全选";
    
    
    }
    return _allOrNoneSelectLb;
}
- (CAGradientLayer *)gratlayer {
    if (!_gratlayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        

        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
        gradientLayer.cornerRadius = 13;
        gradientLayer.masksToBounds = YES;
        _gratlayer = gradientLayer;
        //        [self.layer addSublayer:gradientLayer];
    }
    return _gratlayer;
}
//- (CAGradientLayer *)gratlayerJiesuan {
//    if (!_gratlayerJiesuan) {
//        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//
//
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 0);
//        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
//        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
//        gradientLayer.cornerRadius = 13;
//        gradientLayer.masksToBounds = YES;
//        _gratlayerJiesuan = gradientLayer;
//        //        [self.layer addSublayer:gradientLayer];
//    }
//    return _gratlayerJiesuan;
//}
- (UIButton *)paymentBtn {
    if (!_paymentBtn) {
        _paymentBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-85, 0, 85, 50)];
        [_paymentBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _paymentBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [_paymentBtn addTarget:self action:@selector(payMentClick:) forControlEvents:UIControlEventTouchUpInside];
        _paymentBtn.enabled = NO;
    }
    return _paymentBtn;
}
@end
