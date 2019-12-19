//
//  HFEditingAddressViewController.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFEditingAddressViewController.h"
#import "HFAddressViewModel.h"
#import "HFEditingAddressView.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <ContactsUI/ContactsUI.h>
#import "HFCitySelectorView.h"
#import "HFAddressListViewModel.h"
#import "HFPayMentViewController.h"
#import "WRNavigationBar.h"
@interface HFEditingAddressViewController () <CNContactPickerDelegate,MFMessageComposeViewControllerDelegate>
//@property (nonatomic,strong) HFAddressViewModel *viewModel;
@property (nonatomic,strong) HFAddressListViewModel *viewModel;
@property (nonatomic,strong) HFEditingAddressView *addressView;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)HFCitySelectorView *citySelectoryView;
@end

@implementation HFEditingAddressViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFAddressListViewModel*)viewModel;
    self.source = 1;
    if (self = [super initWithViewModel:viewModel]) {
    
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wr_setNavBarBackgroundAlpha:1];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写收货地址";
    [self.view addSubview:self.addressView];
    @weakify(self);
    [self.viewModel.addressEditSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isEqualToString:@"1"]) {
            BOOL isContainObjc = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[HFPayMentViewController class]]) {
                    isContainObjc = YES;
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            if (isContainObjc == NO) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [MBProgressHUD showAutoMessage:@"修改失败"];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
    [self.viewModel.deleteSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isEqualToString:@"1"]) {
             [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD showAutoMessage:@"删除失败"];
        }
       
    } error:^(NSError * _Nullable error) {
        
    }];
   
//    [self.viewModel.contactsSubj subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//        if (status == CNAuthorizationStatusNotDetermined ||  status == CNAuthorizationStatusDenied) {
//            CNContactStore *store = [[CNContactStore alloc] init];
//            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                if (granted) {
//                    NSLog(@"weishouquan ");
//                }else
//                {
//                    NSLog(@"chenggong ");//用户给权限了
//                    CNContactPickerViewController * picker = [CNContactPickerViewController new];
//                    picker.delegate = self;
//                    picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];//只显示手机号
//                    [self presentViewController: picker  animated:YES completion:nil];
//                }
//            }];
//        }
//        if (status == CNAuthorizationStatusAuthorized) {//有权限时
//            CNContactPickerViewController * picker = [CNContactPickerViewController new];
//            picker.delegate = self;
//            picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
//            [self presentViewController: picker  animated:YES completion:nil];
//        }
//
//    }];
//    [self.viewModel.selectAreaSubj subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        [self.citySelectoryView showCitySelector];
//    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage: [UIImage imageNamed:@"back-b"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn2 setTitle:@"删除" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.rightBtn = btn2;
    if (self.source == 0) {
        self.rightBtn.hidden = YES;
    }else {
        self.rightBtn.hidden = NO;
    }
    self.navigationItem.rightBarButtonItem = right;
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.deleteAddressCommnd execute:nil];
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editingOringModel:(HFAddressModel*)model {
    [self.viewModel.editingSetSubjc sendNext:model];
}
- (void)setSource:(HFEditingEnterSource)source {
    _source = source;
    self.viewModel.source = source;

}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty  {
    CNContact *contact = contactProperty.contact;
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
 
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
//        [[HNPublicTool shareInstance] showHudErrorMessage:@"请选择11位手机号"];
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * Str = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
    NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (phoneStr.length != 11) {
      //  [[HNPublicTool shareInstance] showHudErrorMessage:@"请选择11位手机号"];
    }

}
- (HFEditingAddressView *)addressView {
    if (!_addressView) {
        CGFloat heigt = IS_iPhoneX?64+24:64;
        _addressView = [[HFEditingAddressView alloc] initWithFrame:CGRectMake(0, heigt, ScreenW, ScreenH-heigt) WithViewModel:self.viewModel];
    }
    return _addressView;
}
- (HFAddressListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFAddressListViewModel alloc] init];
        
    }
    return _viewModel;
}

- (HFCitySelectorView *)citySelectoryView {
    if (!_citySelectoryView) {
        _citySelectoryView = [[HFCitySelectorView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
        _citySelectoryView.hidden = YES;
    }
    return _citySelectoryView;
}
@end
