//
//  HFSelectContactsView.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFSelectContactsView.h"
#import "HFAddressListViewModel.h"
#import <ContactsUI/ContactsUI.h>



@interface HFSelectContactsView ()
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *contactsLb;
@property (nonatomic,strong) UIButton *eventBtn;

@property (nonatomic,strong) HFAddressListViewModel *viewModel;

@end
@implementation HFSelectContactsView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFAddressListViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    self.layer.borderWidth = 0.5;
    [self addSubview:self.iconImageV];
    [self addSubview:self.contactsLb];
    [self addSubview:self.eventBtn];
    
}
- (void)hh_bindViewModel {
    self.iconImageV.frame = CGRectMake((110-40)*0.5, 15, 40, 40);
    self.contactsLb.frame = CGRectMake(0, self.iconImageV.bottom+5,110, 15);
    self.eventBtn.frame = CGRectMake(0, 0, 110, 90);
}
- (void)eventClick:(UIButton*)btn {
//    [self.viewModel.contactsSubj sendNext:nil];
}
- (UIButton *)eventBtn {
    if (!_eventBtn) {
        _eventBtn = [[UIButton alloc] init];
        _eventBtn.backgroundColor = [UIColor clearColor];
        [_eventBtn addTarget:self action:@selector(eventClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eventBtn;
}
- (UILabel *)contactsLb {
    if (!_contactsLb) {
        _contactsLb = [[UILabel alloc] init];
        _contactsLb.text = @"联系人";
        _contactsLb.font = [UIFont systemFontOfSize:12];
        _contactsLb.textAlignment = NSTextAlignmentCenter;
        _contactsLb.textColor = [UIColor blackColor];
    }
    return _contactsLb;
}
- (UIImageView *)iconImageV {
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friend_add"]];
    }
    return _iconImageV;
}
@end
