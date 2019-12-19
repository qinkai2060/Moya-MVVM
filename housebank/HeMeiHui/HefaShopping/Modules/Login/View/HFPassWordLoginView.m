//
//  HFPassWordLoginView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//


#import "HFPassWordLoginView.h"
#import "HFLoginViewModel.h"
#import "HFTextCovertImage.h"
#import "HFCountryCodeModel.h"
#import "UITextField+NSinputRange.h"
#import "HFTextField.h"
@interface HFPassWordLoginView()<HFTextFieldDelegate>
@property(nonatomic,strong)UILabel *countryPhoneLb;
@property(nonatomic,strong)UIImageView *selectCountryImgV;
@property(nonatomic,strong)UIButton *coverBtn;
@property(nonatomic,strong)UIView *lineLayer;

@property(nonatomic,strong)HFTextField *userNametextField;
@property(nonatomic,strong)UIView *lineLayer2;

@property(nonatomic,strong)UITextField *passWordTextField;
@property(nonatomic,strong)UIView *lineLayer3;

@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *forgetPassWordBtn;

@property(nonatomic,strong)UILabel *policyLb;
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@property(nonatomic,strong)UIButton *memberBtn;
@property(nonatomic,strong)UIButton *privacyBtn;
@property(nonatomic,strong)CAGradientLayer *gradientlayer;
@property(nonatomic,strong)NSString    *previousTextFieldContent;
@property(nonatomic,strong)UITextRange *previousSelection;
@end
@implementation HFPassWordLoginView {

}
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFLoginViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.selectCountryImgV];
    [self addSubview:self.countryPhoneLb];
    [self addSubview:self.coverBtn];
    [self addSubview:self.lineLayer];
    self.selectCountryImgV.frame = CGRectMake(ScreenW-30-25, 17, 25, 25);
    self.countryPhoneLb.frame = CGRectMake(30, 0, self.selectCountryImgV.left-30, 60);
    self.coverBtn.frame = CGRectMake(30, 0, ScreenW-60, 60);
    self.lineLayer.frame = CGRectMake(30, self.coverBtn.bottom, ScreenW-60, 0.5);
    [self addSubview:self.userNametextField];
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10,10, 2, 30)];
//    v.backgroundColor = [UIColor redColor];
//    self.userNametextField.leftView = v;
    [self addSubview:self.lineLayer2];
    self.userNametextField.frame = CGRectMake(30, self.lineLayer.bottom, ScreenW-60, 60);
    self.lineLayer2.frame = CGRectMake(30, self.userNametextField.bottom, ScreenW-60, 0.5);
    [self addSubview:self.passWordTextField];
    [self addSubview:self.lineLayer3];
    self.passWordTextField.frame = CGRectMake(30, self.lineLayer2.bottom, ScreenW-60, 60);
    self.lineLayer3.frame = CGRectMake(30, self.passWordTextField.bottom, ScreenW-60, 0.5);
    [self.layer addSublayer:self.gradientlayer];
    [self addSubview:self.loginBtn];
    self.loginBtn.frame = CGRectMake(30, self.lineLayer3.bottom+30, ScreenW-60, 50);
    self.gradientlayer.frame = CGRectMake(30, self.lineLayer3.bottom+30, ScreenW-60, 50);
    [self addSubview:self.forgetPassWordBtn];
    self.forgetPassWordBtn.frame = CGRectMake(0, self.loginBtn.bottom+20, ScreenW, 60);
    [self addSubview:self.policyLb];
    self.policyLb.frame = CGRectMake(0, self.height-30-15, ScreenW, 15);
    self.policyLb.attributedText = [HFTextCovertImage attrbuteStr:@"登录即代表您同意《合美惠隐私政策》" rangeOfArray:@[@"《合美惠隐私政策》"] font:12 color:@"F3344A"];
    CGFloat memberX = (ScreenW -  [self.policyLb sizeThatFits:CGSizeMake(ScreenW, 15)].width)*0.5;
    CGFloat  privacyX = [@"登录即代表您同意" boundingRectWithSize:CGSizeMake(ScreenW, 15) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    [self addSubview:self.memberBtn];
    [self addSubview:self.privacyBtn];
    self.memberBtn.frame  = CGRectMake(memberX, self.policyLb.top, privacyX, 15);
    self.privacyBtn.frame = CGRectMake(self.memberBtn.right, self.policyLb.top, [self.policyLb sizeThatFits:CGSizeMake(ScreenW, 15)].width-privacyX, 15);
    
}
- (void)hh_bindViewModel {
    @weakify(self)
    if ([HFUserDataTools userName].length > 0) {
        self.userNametextField.text = [HFUserDataTools userName];
    }
    if ([HFUserDataTools codeValue].length > 0) {
        self.countryPhoneLb.text  = [HFUserDataTools codeValue];
    }
    RAC(self.viewModel, userName)= self.userNametextField.rac_textSignal;
    RAC(self.viewModel,passWord) = self.passWordTextField.rac_textSignal;
    RAC(self.loginBtn,enabled)   = self.viewModel.validSigal;
    RAC(self.loginBtn,backgroundColor) = [self.viewModel.validSigal map:^id _Nullable(id  _Nullable value) {
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
        if ([HFUntilTool isValidateByRegex:self.viewModel.userName]) {
            [SVProgressHUD show];
            [self.viewModel.passWordLoginCommnd execute:nil];
        }else {
            [MBProgressHUD showAutoMessage:@"请输入有效的手机号码"];
        }
        
    }];
    [[self.forgetPassWordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.findPassWordSubject sendNext:self];
    }];
    [[self.coverBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.openCountryCodeSubject sendNext:self];
    }];
    [self.viewModel.didSelectCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFCountryCodeModel *model = (HFCountryCodeModel*)x;
        self.viewModel.countryCode = model.countryCode;
        self.viewModel.countryStr = [NSString stringWithFormat:@"%@ (+%@)",model.countryName,model.countryCode];
        self.countryPhoneLb.text = [NSString stringWithFormat:@"%@ (+%@)",model.countryName,model.countryCode];
    }];
    [self.viewModel.regSuccessPassWordSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.passWord = x;
        self.passWordTextField.text = x;
    }];
    [self.viewModel.regSuccessPhoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.userName = x;
        self.userNametextField.text = x;
    }];
    [[self.memberBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
//        [self.viewModel.memberSubject sendNext:nil];
    }];
    [[self.privacyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.privacySubject sendNext:nil];
    }];
    [self.viewModel.findSuccessPhoneSubject subscribeNext:^(id  _Nullable x) {
         @strongify(self)
        self.viewModel.passWord = @"";
        self.passWordTextField.text = @"";
        
    }];
    [[self.userNametextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self threethreefourFormat];
 
    }];
}
- (void)editingEndSuccess {
    self.viewModel.passWord = @"";
    self.passWordTextField.text = @"";;
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
    NSInteger editFlag = 0;// 正在执行删除操作时为0，否则为1
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
   
    self.userNametextField.text = mStrTemp;

    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
     NSLog(@"curTargetCursorPosition:%li", (long)curTargetCursorPosition);
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
- (UILabel *)policyLb {
    if (!_policyLb) {
        _policyLb = [[UILabel alloc] init];
        _policyLb.text = @"《会员注册协议》和《隐私政策》";
        _policyLb.font = [UIFont systemFontOfSize:12];
        _policyLb.textColor = [UIColor blackColor];
        _policyLb.textAlignment = NSTextAlignmentCenter;
    }
    return _policyLb;
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
- (UIButton *)forgetPassWordBtn {
    if (!_forgetPassWordBtn) {
        _forgetPassWordBtn = [[UIButton alloc] init];
        [_forgetPassWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPassWordBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _forgetPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _forgetPassWordBtn;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
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
- (HFTextField *)userNametextField {
    if (!_userNametextField) {
        _userNametextField = [[HFTextField alloc] init];
        _userNametextField.textColor = [UIColor blackColor];
        _userNametextField.font = [UIFont systemFontOfSize:17];
        _userNametextField.placeholder = @"请输入手机号码";
        _userNametextField.keyboardType = UIKeyboardTypePhonePad;
//        _userNametextField.returnKeyType = UIReturnKeySearch;
        _userNametextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNametextField.delegate = self;
//        _userNametextField.leftViewMode = UITextFieldViewModeWhileEditing;
//        _userNametextField.tintColor = [UIColor clearColor];
 
    }
    return _userNametextField;
}
- (UITextField *)passWordTextField {
    if (!_passWordTextField) {
        _passWordTextField = [[UITextField alloc] init];
        _passWordTextField.textColor = [UIColor blackColor];
        _passWordTextField.font = [UIFont systemFontOfSize:17];
        _passWordTextField.placeholder = @"请输入密码";
        _passWordTextField.returnKeyType = UIReturnKeySearch;
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.delegate = self;
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passWordTextField;
}
- (CAGradientLayer *)gradientlayer {
    if (!_gradientlayer) {
        _gradientlayer = [CAGradientLayer layer];
        _gradientlayer.frame = CGRectMake(30, self.lineLayer3.bottom+30, ScreenW-60, 50);
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
