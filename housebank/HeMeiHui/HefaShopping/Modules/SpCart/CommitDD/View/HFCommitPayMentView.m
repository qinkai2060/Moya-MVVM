//
//  HFCommitPayMentView.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCommitPayMentView.h"
#import "HFTextCovertImage.h"
#import "HFPaymentBaseModel.h"
@interface HFCommitPayMentView ()
@property (nonatomic,strong) UIButton *paymentBtn;
@property (nonatomic,strong) UILabel *payMentPriceLb;
@property(nonatomic,strong) HFPayMentViewModel *viewmodel;

@end
@implementation HFCommitPayMentView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewmodel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
       
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    v.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:v];
    [self addSubview:self.paymentBtn];
    [self addSubview:self.payMentPriceLb];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewmodel.orderDetialSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         self.payMentPriceLb.attributedText = [HFTextCovertImage exchangeFinalString:[NSString stringWithFormat:@"合计:%@",[HFUntilTool thousandsFload:self.viewmodel.payMentModel.allPrice]]];
      
    }];
      [self.viewmodel.commitOrderSubjc subscribeNext:^(id  _Nullable x) {
            @strongify(self)
          [MBProgressHUD hideHUDForView:self.superview animated:YES];
      }];
    [self.viewmodel.getPostAgeSubjc subscribeNext:^(id  _Nullable x) {
          @strongify(self)
        NSArray *arrayData = (NSArray*)x;
        CGFloat price = 0;
        for (HFOrderShopModel *smallModel in arrayData) {
            price+=smallModel.shopAllPostages;
        }
        if (self.viewmodel.payMentModel.contentMode == HFOrderShopModelTypeSelected ) {
            CGFloat totalPrice = self.viewmodel.payMentModel.allPrice +price-self.viewmodel.payMentModel.allIntegralPrice;
            self.viewmodel.payMentModel.allPrice = totalPrice;
            
        }else {
            CGFloat totalPrice  = self.viewmodel.payMentModel.allPrice +price;
            self.viewmodel.payMentModel.allPrice = totalPrice;
        }
         self.payMentPriceLb.attributedText = [HFTextCovertImage exchangeFinalString:[NSString stringWithFormat:@"合计:%@",[HFUntilTool thousandsFload:self.viewmodel.payMentModel.allPrice]]];

    }];
    [self.viewmodel.getAllPriceSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self)
//        if (self.viewmodel.payMentModel.allPrice>0) {
             self.payMentPriceLb.attributedText = [HFTextCovertImage exchangeFinalString:[NSString stringWithFormat:@"合计:%@",[HFUntilTool thousandsFload:self.viewmodel.payMentModel.allPrice]]];
//        }
        
    }];
}
- (void)payMentClick :(UIButton*)btn {
  
   

    [self.viewmodel.commitSubjc sendNext:nil];


}
- (UILabel *)payMentPriceLb {
    if (!_payMentPriceLb) {
        _payMentPriceLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, ScreenW-110-5 , 49.5)];
        _payMentPriceLb.textAlignment = NSTextAlignmentRight;
    }
    return _payMentPriceLb;
}
- (UIButton *)paymentBtn {
    if (!_paymentBtn) {
        _paymentBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-110, 0.5, 110, 49.5)];
        [_paymentBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _paymentBtn.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
        [_paymentBtn addTarget:self action:@selector(payMentClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _paymentBtn;
}

@end
