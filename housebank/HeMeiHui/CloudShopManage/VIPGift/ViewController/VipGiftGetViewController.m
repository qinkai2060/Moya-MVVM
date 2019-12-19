//
//  VipGiftGetViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftGetViewController.h"
#import "VipGiftBagViewController.h"
#import "VipGiftPopView.h"
#import "VipLoadViewModel.h"
#import "HFCountryViewController.h"
#import "HFLoginViewModel.h"
#import "HFCountryCodeModel.h"
#import "CloudVipAlertView.h"
@interface VipGiftGetViewController ()
@property (nonatomic, strong)UITextField * inputTF;
@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, strong)UILabel * phoneLB;
@property (nonatomic, strong)VipGiftPopView * popView;
@property (nonatomic, strong)VipLoadViewModel * viewModel;
@property (nonatomic, strong)UIButton * sureBtn;
@property (nonatomic, strong)UIButton * giftBtn;
@property (nonatomic, strong)UIButton * leftBtn;
@property (nonatomic, strong)HFLoginViewModel *loginViewMode;
@property (nonatomic, strong)CloudVipAlertView * alertView;
@end

@implementation VipGiftGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isHave = NO;
    [self setUpUI];
    [self bindRAC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.customNavBar.hidden = YES;
}

- (void)bindRAC {
    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.inputTF.text.length > 20) {
            // 输入正确电话号码
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"您输入的手机号码有误"];
        }else {
            @strongify(self);
            [[self.viewModel loadRequest_getUserInfoByLoginNameWithPhone:[self get_returnPhoneString]]subscribeNext:^(NSDictionary * x) {
                if (x) {
                    self.isHave = YES;
                    [self makeUpdateUI];
                    [self.iconImage sd_setImageWithURL:[objectOrEmptyStr([x objectForKey:@"headImagePath"]) get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                    self.phoneLB.text = [NSString stringWithFormat:@"%@",objectOrEmptyStr([x objectForKey:@"name"])];
                }
            } error:^(NSError * _Nullable error) {
                NSString * errorString = [error.userInfo objectForKey:@"error"];
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:errorString];
            }];
        }
    }];
    
    [[self.giftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //  输入空手机号，显示弹框
        if (![self.inputTF.text isNotNil]) {
            [self.alertView showAlertString:@"确定推荐人为空吗?" isSure:YES changeBlock:^{
                @strongify(self);
                [self getSureRequest];
            }];
        }else {
            [self getSureRequest];
        }
    }];
    
    [[self.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        HFCountryViewController *countryVC = [[HFCountryViewController alloc] initWithViewModel:self.loginViewMode];
        [self presentViewController:countryVC animated:YES completion:nil];
    }];
    
    [self.loginViewMode.didSelectCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryCodeModel *model = (HFCountryCodeModel*)x;
        self.loginViewMode.countryCode = model.countryCode;
        NSString * leftStrng = [NSString stringWithFormat:@"+%@  |",self.loginViewMode.countryCode];
        [self.leftBtn setTitle:leftStrng forState:UIControlStateNormal];
    }];
}

- (void)getSureRequest {
    @weakify(self);
    [[self.viewModel loadRequest_getUserDefinWithPhone:[self get_returnPhoneString]]subscribeNext:^(NSString * x) {
        if ([x isEqualToString:@"YES"]) {
            VipGiftBagViewController * bagVC= [[VipGiftBagViewController alloc]init];
            if(self.alertView){  [self.alertView removeFromSuperview];};
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.navigationController pushViewController:bagVC animated:YES];
            });
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        if(self.alertView){  [self.alertView removeFromSuperview];};
        NSString * errorString = [error.userInfo objectForKey:@"error"];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:errorString];
    }];
}

- (NSString *)get_returnPhoneString {
    NSString * iphoneParams;
    if (![self.loginViewMode.countryCode isEqualToString:@"86"]) {
        iphoneParams = [NSString stringWithFormat:@"%@ %@",objectOrEmptyStr(self.loginViewMode.countryCode),self.inputTF.text];
    }else {
        iphoneParams = self.inputTF.text;
    }
    return iphoneParams;
}
- (void)setUpUI {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"VIPGiftBg" ofType:@"png"];
    UIImage * image;
    if ([UIDevice currentDevice].systemVersion.doubleValue>=8.0) {
        image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        image = [UIImage imageWithContentsOfFile:[filePath stringByAppendingString:@"@2x.png"]];
    }
    UIImageView *bgView = [[UIImageView alloc]initWithImage:image];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 0, kWidth, kHeight);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(18, 42, 20,30);
    [backBtn setImage:[UIImage imageNamed:@"首页-返回白色"] forState:UIControlStateNormal];
    [bgView addSubview:backBtn];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIViewController visibleViewController].navigationController popViewControllerAnimated:YES];
    }];
    
    UIImageView * logView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VIPLogo"]];
    [bgView addSubview:logView];
    [logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(174);
        make.centerX.equalTo(bgView);
        make.height.equalTo(@28);
    }];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"礼包隆重上线";
    titleLabel.font = kFONT_BOLD(22);
    titleLabel.textColor = [UIColor colorWithHexString:@"#FFE8AC"];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logView.mas_bottom).offset(12);
        make.centerX.equalTo(bgView);
        make.height.equalTo(@20);
    }];
    
    UILabel * phoneLabel = [UILabel new];
    phoneLabel.text = @"请填写推荐人手机号（非必填）";
    phoneLabel.font = kFONT(12);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor colorWithHexString:@"#FEECBB"];
    [bgView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(23);
        make.left.equalTo(bgView).offset(75);
        make.height.equalTo(@17);
    }];
    
    [bgView addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel);
        make.top.equalTo(phoneLabel.mas_bottom).offset(11);
        make.height.equalTo(@35);
        make.width.equalTo(@(WScale(167)));
    }];
    
    self.leftBtn.frame = CGRectMake(0, 0, 57, 30);
    self.inputTF.leftView = self.leftBtn;
    self.inputTF.leftViewMode = UITextFieldViewModeAlways;
    
    [bgView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_right);
        make.width.equalTo(@58);
        make.height.equalTo(@35);
        make.top.equalTo(self.inputTF);
    }];
    
    CGFloat Height = self.isHave? 70.f:20;
    self.iconImage.hidden = !self.isHave;
    [bgView addSubview:self.iconImage];
    self.iconImage.backgroundColor = [UIColor redColor];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel);
        make.top.equalTo(self.inputTF.mas_bottom).offset(15);
        make.width.height.equalTo(@40);
    }];
    
    self.phoneLB.hidden = !self.isHave;
    [bgView addSubview:self.phoneLB];
    self.phoneLB.text = @"H84942251";
    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage);
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.height.equalTo(@17);
    }];
    
    [bgView addSubview:self.giftBtn];
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.mas_bottom).offset(Height);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@(WScale(225)));
        make.height.equalTo(@50);
    }];
}

- (void)makeUpdateUI {
    CGFloat Height = self.isHave? 70.f:20;
    self.iconImage.hidden = !self.isHave;
    self.phoneLB.hidden = !self.isHave;
    [self.giftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.mas_bottom).offset(Height);
    }];
}

#pragma mark -- lazy load
- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftBtn.layer.masksToBounds = YES;
        _giftBtn.layer.cornerRadius = 6;
        _giftBtn.backgroundColor = [UIColor colorWithHexString:@"#FEECBB"];
        [_giftBtn setTitle:@"进入礼包区" forState:UIControlStateNormal];
        [_giftBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        _giftBtn.titleLabel.font = kFONT(16);
    }
    return _giftBtn;
}

- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[UITextField alloc]init];
        _inputTF.backgroundColor = [UIColor whiteColor];
        _inputTF.textColor = [UIColor colorWithHexString:@"#333333"];
        _inputTF.font = kFONT(12);
        _inputTF.keyboardType = UIKeyboardTypeNumberPad;
        _inputTF.borderStyle = UITextBorderStyleRoundedRect;
        _inputTF.placeholder = @"请输入";
    }
    return _inputTF;
}

- (UIImageView *)iconImage {
    if(!_iconImage){
        _iconImage = [[UIImageView alloc]init];
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius  = 20;
    }
    return _iconImage;
}

- (UILabel *)phoneLB {
    if(!_phoneLB){
        _phoneLB = [UILabel new];
        _phoneLB.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _phoneLB.font = kFONT(12);
    }
    return _phoneLB;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#FEECBB"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kFONT(14);
    }
    return _sureBtn;
}

- (VipLoadViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[VipLoadViewModel alloc]init];
    }
    return _viewModel;
}

- (HFLoginViewModel *)loginViewMode {
    if (!_loginViewMode) {
        _loginViewMode = [[HFLoginViewModel alloc]init];
    }
    return _loginViewMode;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"+86  |" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = kFONT(12);
    }
    return _leftBtn;
}

- (CloudVipAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CloudVipAlertView alloc]init];
        _alertView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    }
    return _alertView;
}
@end
