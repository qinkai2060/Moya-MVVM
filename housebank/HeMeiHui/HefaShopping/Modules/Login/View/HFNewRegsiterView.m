//
//  HFRegsiterView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNewRegsiterView.h"
#import "HFLoginViewModel.h"
#import "HFTextCovertImage.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "HFGCDManger.h"
#import "HFCountryCodeModel.h"
#import "HFTextField.h"
@interface HFNewRegsiterView()<HFTextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@property(nonatomic,strong)UIButton *phoneRegBtn; // 手机注册

@property(nonatomic,strong)UILabel *countryPhoneLb;
@property(nonatomic,strong)UIImageView *selectCountryImgV;
@property(nonatomic,strong)UIButton *coverBtn;
@property(nonatomic,strong)UIView *lineLayer;

@property(nonatomic,strong)HFTextField *userNametextField;
@property(nonatomic,strong)UIView *lineLayer2;

@property(nonatomic,strong)UITextField *passWordTextField;
@property(nonatomic,strong)UIView *lineLayer3;

@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UILabel *getCodeLb;
@property(nonatomic,strong)UIButton *getCodeBtn;
@property(nonatomic,strong)UIView *lineLayer4;


@property(nonatomic,strong)UIButton *agreePolicyBtn;
@property(nonatomic,strong)UILabel *agreePolicyLb;

@property(nonatomic,strong)UIButton *loginBtn; // 注册
@property(nonatomic,strong)UIButton *memberBtn;
@property(nonatomic,strong)UIButton *privacyBtn;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)CAGradientLayer *gradientlayer;
@property(nonatomic,strong)NSString *phone;

@property(nonatomic,strong)NSString    *previousTextFieldContent;
@property(nonatomic,strong)UITextRange *previousSelection;
@end
@implementation HFNewRegsiterView


- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFLoginViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
    
}
- (void)hh_setupViews {

        self.phoneRegBtn.frame = CGRectMake(30, 30, 90, 30);
        [self addSubview:self.phoneRegBtn];
        [self addSubview:self.selectCountryImgV];
        [self addSubview:self.countryPhoneLb];
        [self addSubview:self.coverBtn];
        [self addSubview:self.lineLayer];
        self.selectCountryImgV.frame = CGRectMake(ScreenW-30-25, self.phoneRegBtn.bottom+29+17, 25, 25);
        self.countryPhoneLb.frame = CGRectMake(30, self.phoneRegBtn.bottom+30, self.selectCountryImgV.left-30, 60);
        self.coverBtn.frame = CGRectMake(30, self.phoneRegBtn.bottom+30, ScreenW-60, 60);
        self.lineLayer.frame = CGRectMake(30, self.coverBtn.bottom, ScreenW-60, 0.5);
        [self addSubview:self.userNametextField];
        [self addSubview:self.lineLayer2];
        self.userNametextField.frame = CGRectMake(30, self.lineLayer.bottom, ScreenW-60, 60);
        self.lineLayer2.frame = CGRectMake(30, self.userNametextField.bottom, ScreenW-60, 0.5);
        [self addSubview:self.passWordTextField];
        [self addSubview:self.lineLayer3];
        self.passWordTextField.frame = CGRectMake(30, self.lineLayer2.bottom, ScreenW-60, 60);
        self.lineLayer3.frame = CGRectMake(30, self.passWordTextField.bottom, ScreenW-60, 0.5);
       [self addSubview:self.getCodeLb];
       [self addSubview:self.getCodeBtn];
       [self addSubview:self.codeTextField];
       [self addSubview:self.lineLayer4];
    self.getCodeLb.frame = CGRectMake(ScreenW-30-130, self.lineLayer3.bottom, 130, 60);
    self.getCodeBtn.frame = CGRectMake(ScreenW-30-80, self.lineLayer3.bottom, 80, 60);
    self.codeTextField.frame = CGRectMake(30, self.lineLayer3.bottom, self.getCodeLb.left-10-30, 60);
    self.lineLayer4.frame = CGRectMake(30, self.codeTextField.bottom, ScreenW-60, 0.5);
    self.getCodeLb.textAlignment = NSTextAlignmentRight;
       [self addSubview:self.agreePolicyBtn];
       [self addSubview:self.agreePolicyLb];
       self.agreePolicyBtn.frame = CGRectMake(30, self.lineLayer4.bottom+20, 20, 20);
       self.agreePolicyLb.frame = CGRectMake(self.agreePolicyBtn.right+5, self.lineLayer4.bottom+22, ScreenW-30-self.agreePolicyBtn.right-10, 15);
    [self.layer addSublayer:self.gradientlayer];
    [self addSubview:self.loginBtn];
    
    self.loginBtn.frame = CGRectMake(30, self.agreePolicyLb.bottom+20, ScreenW-60, 50);
    self.gradientlayer.frame = self.loginBtn.frame;
    self.agreePolicyLb.attributedText = [HFTextCovertImage attrbuteStr:@"我已阅读并同意《会员注册协议》和《隐私政策》" rangeOfArray:@[@"《会员注册协议》",@"《隐私政策》"] font:12 color:@"F3344A"];
    CGFloat totalW = [self.agreePolicyLb sizeThatFits:CGSizeMake(ScreenW, 20)].width;
    CGFloat totalX = (ScreenW - totalW)*0.5;
    CGFloat meAgree = [@"我已阅读并同意《会员注册协议》和" boundingRectWithSize:CGSizeMake(ScreenW, 15) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    CGFloat memberW = [@"《会员注册协议》和" boundingRectWithSize:CGSizeMake(ScreenW, 15) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    self.memberBtn.frame = CGRectMake(totalX+(meAgree-memberW), self.agreePolicyLb.top, memberW, 20);
    self.privacyBtn.frame = CGRectMake(self.memberBtn.right, self.agreePolicyLb.top, totalW-meAgree, 20);
    //    self.memberBtn.backgroundColor = [UIColor redColor];
    //    self.privacyBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:self.memberBtn];
    [self addSubview:self.privacyBtn];
        
}
- (void)hh_bindViewModel {
    @weakify(self)
    RAC(self.viewModel, regPhone)= self.userNametextField.rac_textSignal;
    RAC(self.viewModel,regCode) = self.codeTextField.rac_textSignal;
    RAC(self.viewModel,regPassWord) = self.passWordTextField.rac_textSignal;
    [[self.coverBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        [self.viewModel.openCountryCodeSubject sendNext:self];
    }];
    [self.passWordTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSString *toBeString = x;
   
        if (toBeString.length >= 20) {
            self.passWordTextField.text = [toBeString substringToIndex:20];
            [MBProgressHUD showAutoMessage:@"超过限制字符数"];
        }
    }];
    [[self.userNametextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        
        if ((![self.phone isEqualToString:self.viewModel.regPhone]) || self.viewModel.userName.length == 0) {
            [[HFGCDManger sharedInstance] cancelTimerWithName:@"HFNewRegsiterView"];
            self.getCodeBtn.enabled = YES;
            [self.getCodeLb setText:@"获取验证码" ];
        }
        
        [self threethreefourFormat];

    }];
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]  subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if ([[[x allObjects] firstObject] isKindOfClass:[UITextField class]]) {
            UITextField *tF = (UITextField*)([[x allObjects] firstObject]);
            self.phone =  [[tF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }];
    RAC(self.loginBtn,enabled)   = self.viewModel.regValidSigal;
    RAC(self.loginBtn,backgroundColor) = [self.viewModel.regValidSigal map:^id _Nullable(id  _Nullable value) {
        if ([value boolValue]) {
            self.gradientlayer.hidden = NO;
            return [UIColor clearColor];
        }else {
            self.gradientlayer.hidden = YES;
            return [UIColor colorWithHexString:@"DDDDDD"];
        }
    }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        if (self.viewModel.regAgree) {
            if ([HFUntilTool isValidateByRegex:self.viewModel.regPhone]) {
                if (self.viewModel.regPassWord.length <8) {
                    [MBProgressHUD showAutoMessage:@"请输入8-20位数字和字母密码组合"];
                }else {
                    [self.viewModel.regCommnd execute:nil];
                }
            }else {
                [MBProgressHUD showAutoMessage:@"请输入有效的手机号码"];
            }
        }else {
            [MBProgressHUD showAutoMessage:@"请阅读隐私政策和会员注册协议 并同意"];
        }
    }];
    [[self.agreePolicyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.agreePolicyBtn.selected = !x.isSelected;
        self.viewModel.regAgree = self.agreePolicyBtn.selected;
    }];
    [[self.getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        if ([HFUntilTool isValidateByRegex:self.viewModel.regPhone]) {
            
            [self.manager openVerifyCodeView:nil];
        }else {
            [MBProgressHUD showAutoMessage:@"请输入有效的手机号码"];
        }
    }];
    [[self rac_signalForSelector:@selector(verifyCodeValidateFinish:validate:message:) fromProtocol:@protocol(NTESVerifyCodeManagerDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if([[x first] boolValue]) {

            if ([x allObjects].count >= 3) {
                self.viewModel.regNECaptchaValidate = [[x allObjects] objectAtIndex:1];
            }
            if (self.viewModel.regNECaptchaValidate) {
                [self codeValite];
                [self.viewModel.regsendCodeCommnd execute:nil];
                
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"验证未通过"];
            [SVProgressHUD dismissWithDelay:0.25];
        }

        NSLog(@"");
    }];
    [self.viewModel.didSelectCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryCodeModel *model = (HFCountryCodeModel*)x;
        self.viewModel.regcountryCode = model.countryCode;
        self.countryPhoneLb.text = [NSString stringWithFormat:@"%@ (+%@)",model.countryName,model.countryCode];
    }];
    [[self.memberBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.memberSubject sendNext:nil];
    }];
    [[self.privacyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.privacySubject sendNext:nil];
    }];
}
- (void)agreePrivateProtocol {
    self.agreePolicyBtn.selected = YES;
     self.viewModel.regAgree = YES;
}
- (void)codeValite {
    __block NSInteger count = 60;
    self.getCodeBtn.enabled = NO;
    @weakify(self)
    [[HFGCDManger sharedInstance] scheduledDispatchTimerWithName:@"HFNewRegsiterView" timeInterval:1 queue:nil repeats:YES fireInstantly:YES action:^{
        @strongify(self)
        count--;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (count == 0) {
                [[HFGCDManger sharedInstance] cancelTimerWithName:@"HFNewRegsiterView"];
                self.getCodeBtn.enabled = YES;
                count = 60;
                [self.getCodeLb setText:@"重新获取验证码"];
            }else {
                [self.getCodeLb setText:[NSString stringWithFormat:@"(%ld秒)重新发送",count]];
            }
        });
    }];
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.userNametextField]) {
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
        if (range.location == 0)
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest)
            {
                //[self showMyMessage:@"只能输入数字"];
                //                return NO;
            }
        }
        else if (range.location == 1)
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"^[1,2,3,4,5,6,7,8,9,0]$"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest)
            {
                //[self showMyMessage:@"只能输入数字"];
                return NO;
            }
        }
        if (range.location > 12&&textField.text.length>13)
        {
            
            return NO;
        }
        return YES;
    }
    return YES;
}
- (void)threethreefourFormat {
    
    NSUInteger targetCursorPosition = [self.userNametextField offsetFromPosition:self.userNametextField.beginningOfDocument toPosition:self.userNametextField.selectedTextRange.start];
    
    //    NSLog(@"targetCursorPosition:%li", (long)targetCursorPosition);
    NSString *nStr = [self.userNametextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* preTxt = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    char editFlag = 0;// 正在执行删除操作时为0，否则为1
    if (nStr.length <= preTxt.length) {
        editFlag = 0;
    }else{    editFlag = 1;
    }
    if (nStr.length > 11) {
        self.userNametextField.text = self.previousTextFieldContent;
        self.userNametextField.selectedTextRange = self.previousSelection;
        return;
    }
    NSString* spaceStr = @" ";
    NSMutableString *mStrTemp = [NSMutableString string];
    int spaceCount = 0;
    if (nStr.length < 3 && nStr.length > -1) {
        spaceCount = 0;
    }else if (nStr.length < 7&& nStr.length > 2){
        spaceCount = 1;
    }else if (nStr.length < 12&& nStr.length > 6){
        spaceCount = 2;
    }
    for (int i = 0; i < spaceCount; i++){
        if (i == 0) {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)],spaceStr];
        }else if (i == 1){
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
        }else if (i == 2){
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
    }
    
    if (nStr.length == 11){
        [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
    }
    
    if (nStr.length < 4 && nStr.length > 0){
        [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length-nStr.length % 3,nStr.length % 3)]];
    }else if(nStr.length > 3){
        NSString *str = [nStr substringFromIndex:3];
        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,str.length % 4)]];
        if (nStr.length == 11){
            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    NSLog(@"=======mstrTemp=%@",mStrTemp);
    self.userNametextField.text = mStrTemp;
    //  targetCursorPosition =   [self.userNametextField offsetFromPosition:self.userNametextField.beginningOfDocument toPosition:self.userNametextField.selectedTextRange.start];
    //  textField设置selectedTextRange
    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
    if (editFlag == 0){
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4){
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }
    else {
        //添加
        if (nStr.length == 8 || nStr.length == 4){
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [self.userNametextField positionFromPosition:[self.userNametextField beginningOfDocument] offset:curTargetCursorPosition];
    
    
    [self.userNametextField setSelectedTextRange:[self.userNametextField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    
    
    
    
}
- (NTESVerifyCodeManager *)manager {
    if (!_manager) {
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        // 设置透明度
        _manager.alpha = 0.3;
        // 设置frame
        _manager.frame = CGRectNull;
        
        // 常规验证码（滑块拼图、图中点选、短信上行）
        NSString *captchaid = @"5b4a92fe352b4e8a98f75023d788a403";
//        _manager.mode = NTESVerifyCodeNormal;
        [_manager configureVerifyCode:captchaid timeout:10.0];
    }
    return _manager;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginBtn.layer.cornerRadius =  25;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}
- (UILabel *)countryPhoneLb {
    if (!_countryPhoneLb) {
        _countryPhoneLb = [[UILabel alloc] init];
        _countryPhoneLb.textColor = [UIColor colorWithHexString:@"333333"];
        _countryPhoneLb.font = [UIFont systemFontOfSize:17];
        _countryPhoneLb.text = @"中国 (+86)";
    }
    return _countryPhoneLb;
}
- (UIImageView *)selectCountryImgV {
    if (!_selectCountryImgV) {
        _selectCountryImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-arrow"]];
    }
    return _selectCountryImgV;
}
- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc] init];
    }
    return _coverBtn;
}
- (UIView *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[UIView alloc] init];
        _lineLayer.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    }
    return _lineLayer;
}
- (UIView *)lineLayer2 {
    if (!_lineLayer2) {
        _lineLayer2 = [[UIView alloc] init];
        _lineLayer2.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    }
    return _lineLayer2;
}
- (UIView *)lineLayer3 {
    if (!_lineLayer3) {
        _lineLayer3 = [[UIView alloc] init];
        _lineLayer3.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    }
    return _lineLayer3;
}
- (UIView *)lineLayer4 {
    if (!_lineLayer4) {
        _lineLayer4 = [[UIView alloc] init];
        _lineLayer4.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    }
    return _lineLayer4;
}
- (HFTextField *)userNametextField {
    if (!_userNametextField) {
        _userNametextField = [[HFTextField alloc] init];
        _userNametextField.textColor = [UIColor blackColor];
        _userNametextField.font = [UIFont systemFontOfSize:17];
        _userNametextField.placeholder = @"请输入手机号码";
        _userNametextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _userNametextField.keyboardType = UIKeyboardTypePhonePad;
        _userNametextField.delegate = self;
    }
    return _userNametextField;
}
- (UITextField *)passWordTextField {
    if (!_passWordTextField) {
        _passWordTextField = [[UITextField alloc] init];
        _passWordTextField.textColor = [UIColor blackColor];
        _passWordTextField.font = [UIFont systemFontOfSize:14];
        _passWordTextField.placeholder = @"请输入密码";
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.delegate = self;
        _passWordTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    }
    return _passWordTextField;
}
- (UIButton *)memberBtn {
    if (!_memberBtn) {
        _memberBtn = [[UIButton alloc] init];
    }
    return _memberBtn;
}
- (UIButton *)privacyBtn {
    if (!_privacyBtn) {
        _privacyBtn = [[UIButton alloc] init];
    }
    return _privacyBtn;
}
- (UILabel *)agreePolicyLb {
    if (!_agreePolicyLb) {
        _agreePolicyLb = [[UILabel alloc] init];
        _agreePolicyLb.text = @"我已阅读并同意《会员注册协议》和《隐私政策》";
        _agreePolicyLb.font = [UIFont systemFontOfSize:12];
        _agreePolicyLb.textColor = [UIColor blackColor];
    }
    return _agreePolicyLb;
}
- (UIButton *)agreePolicyBtn {
    if (!_agreePolicyBtn) {
        _agreePolicyBtn = [[UIButton alloc] init];
        [_agreePolicyBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_agreePolicyBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateSelected];
    }
    return _agreePolicyBtn;
}
- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
    }
    return _getCodeBtn;
}
- (UILabel *)getCodeLb {
    if (!_getCodeLb) {
        _getCodeLb = [[UILabel alloc] init];
        _getCodeLb.font = [UIFont systemFontOfSize:15];
        _getCodeLb.text = @"获取验证码";
        _getCodeLb.textColor = [UIColor colorWithHexString:@"F3344A"];
    }
    return _getCodeLb;
}
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.textColor = [UIColor blackColor];
        _codeTextField.font = [UIFont systemFontOfSize:14];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}
- (UIButton *)phoneRegBtn {
    if (!_phoneRegBtn) {
        _phoneRegBtn = [[UIButton alloc] init];
        [_phoneRegBtn setTitle:@"手机注册" forState:UIControlStateNormal];
        [_phoneRegBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [_phoneRegBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _phoneRegBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _phoneRegBtn.selected = YES;
    }
    return _phoneRegBtn;
}
/**
 CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
 gradientLayer.frame = self.bounds;

 [gradientLayer setColors:colorArray];//渐变数组
 [self.layer addSublayer:gradientLayer];
 */
- (CAGradientLayer *)gradientlayer {
    if (!_gradientlayer) {
        _gradientlayer = [CAGradientLayer layer];
        _gradientlayer.startPoint = CGPointMake(0, 0);
        _gradientlayer.endPoint = CGPointMake(1, 0);
        _gradientlayer.locations = @[@(0.0),@(1.0)];//渐变点
         [_gradientlayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        _gradientlayer.cornerRadius = 25;
        _gradientlayer.masksToBounds = YES;
    }
    return _gradientlayer;
}
@end
