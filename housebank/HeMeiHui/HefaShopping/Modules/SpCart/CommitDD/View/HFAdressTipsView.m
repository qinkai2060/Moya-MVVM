//
//  HFAdressTipsView.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAdressTipsView.h"
#import "HFPayMentViewModel.h"
@interface HFAdressTipsView ()
@property (nonatomic,strong)UILabel *addressLb;

@property(nonatomic,strong) HFPayMentViewModel *viewmodel;
@end
@implementation HFAdressTipsView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewmodel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.addressLb];
}
- (void)hh_bindViewModel {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFBD3"];
    @weakify(self)
    [self.viewmodel.addressSubj subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFAddressModel *model = (HFAddressModel*)x;
        if (model.completeAddress.length >0) {
            self.addressLb.text = model.completeAddress;
        }else {
            self.addressLb.text = @"暂无收货地址";
        }

        CGSize size = [self.addressLb sizeThatFits:CGSizeMake(ScreenW-30, MAXFLOAT)];
        self.addressLb.frame = CGRectMake(15, 15, size.width, size.height);
        self.frame = CGRectMake(0, self.superview.height-50-self.addressLb.bottom-12, ScreenW, self.addressLb.bottom+9+12);
        
    }];
     [self.viewmodel.resetAddressSubjc subscribeNext:^(id  _Nullable x) {
         HFAddressModel *model = (HFAddressModel*)x;
         self.addressLb.text = model.completeAddress;
         CGSize size = [self.addressLb sizeThatFits:CGSizeMake(ScreenW-30, MAXFLOAT)];
         self.addressLb.frame = CGRectMake(15, 15, size.width, size.height);
         self.frame = CGRectMake(0, self.superview.height-50-self.addressLb.bottom-12, ScreenW, self.addressLb.bottom+9+12);
     }];

    
}
- (CGFloat)tipsheight{
    return self.addressLb.height+9+12;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [[UILabel alloc] init];
        _addressLb.font = [UIFont systemFontOfSize:14];
        _addressLb.textColor = [UIColor colorWithHexString:@"EF8636"];
        _addressLb.numberOfLines = 0;
    }
    return _addressLb;
}
@end
