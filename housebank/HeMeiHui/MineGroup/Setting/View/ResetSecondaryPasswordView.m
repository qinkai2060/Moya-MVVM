//
//  ResetSecondaryPasswordView.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ResetSecondaryPasswordView.h"
#import "UIView+addGradientLayer.h"

@interface ResetSecondaryPasswordView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *buttonSendTestCode;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t _timer;
@end

@implementation ResetSecondaryPasswordView
{
    UIButton *btnSubmit;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(165);
    }];
    
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"手机号";
    phone.textColor = HEXCOLOR(0x333333);
    phone.font = PFR14Font;
    [self addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    _labelPhone = [[UILabel alloc] init];
    _labelPhone.text = [ResetSecondaryPasswordView replaceStringWithAsterisk:USERDEFAULT(@"mobilephone") startLocation:3 lenght:4];
    _labelPhone.textColor = HEXCOLOR(0x333333);
    _labelPhone.font = PFR14Font;
    _labelPhone.textAlignment = NSTextAlignmentRight;
    [self addSubview:_labelPhone];
    [_labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 55));
    }];
    
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelPhone.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
    
    UILabel *verificationCode = [[UILabel alloc] init];
    verificationCode.text = @"验证码";
    verificationCode.textColor = HEXCOLOR(0x333333);
    verificationCode.font = PFR14Font;
    [self addSubview:verificationCode];
    [verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(line0.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    self.buttonSendTestCode = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.buttonSendTestCode setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    [self.buttonSendTestCode setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
    //    self.buttonSendTestCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.buttonSendTestCode.titleLabel.font = PFR15Font;
    [self.buttonSendTestCode addTarget:self action:@selector(sendTestCodeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.buttonSendTestCode];
    [self.buttonSendTestCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75);
        make.centerY.equalTo(verificationCode);
        make.height.mas_equalTo(55);
        make.right.equalTo(self).offset(-15);
    }];
    
    
    _textfVerificationCode = [[UITextField alloc] init];
    _textfVerificationCode.textColor = HEXCOLOR(0x333333);
    _textfVerificationCode.delegate = self;
    _textfVerificationCode.placeholder = @"请输入验证码";
    _textfVerificationCode.textAlignment = NSTextAlignmentRight;
    _textfVerificationCode.keyboardType = UIKeyboardTypeNumberPad;
    _textfVerificationCode.font = PFR14Font;
    [_textfVerificationCode setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    [self addSubview:_textfVerificationCode];
    [_textfVerificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationCode.mas_right).offset(15);
        make.centerY.equalTo(verificationCode);
        make.height.mas_equalTo(55);
        make.right.equalTo(self.buttonSendTestCode.mas_left).offset(-15);
    }];
    
    
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationCode.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
    
    UILabel *password = [[UILabel alloc] init];
    password.text = @"新密码";
    password.textColor = HEXCOLOR(0x333333);
    password.font = PFR14Font;
    [self addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(line1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfNewSerceCode = [[UITextField alloc] init];
    _textfNewSerceCode.textColor = HEXCOLOR(0x333333);
    _textfNewSerceCode.delegate = self;
    _textfNewSerceCode.placeholder = @"请设置新密码";
    _textfNewSerceCode.font = PFR14Font;
    _textfNewSerceCode.secureTextEntry = YES;
    _textfNewSerceCode.textAlignment = NSTextAlignmentRight;
    [self addSubview:_textfNewSerceCode];
    [_textfNewSerceCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(password);
        make.size.mas_equalTo(CGSizeMake(200, 55));
    }];
    
    btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSubmit setTitle:@"确认" forState:(UIControlStateNormal)];
    btnSubmit.titleLabel.font = PFR16Font;
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSubmit.backgroundColor = HEXCOLOR(0xDDDDDD);
    btnSubmit.userInteractionEnabled = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
        
    }];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.numberOfLines = 0;
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_textfNewSerceCode.mas_bottom).offset(20);
    }];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"提示信息："attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    labelTitle.attributedText = string;
    
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"1.请您在30分钟内输入验证码，同时请以最后一次收到验证码为准。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    label1.attributedText = string1;
    
    
    
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.numberOfLines = 0;
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"2.一周之内，只能进行五次密码找回，五次之后将会被锁定。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    label2.attributedText = string2;
    
    
    
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.numberOfLines = 0;
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"3.如果您长时间收不到短信可以尝试致电客服电话：021-64300701"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    label3.attributedText = string3;
    
    
}
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght

{
    
    NSString *newStr = originalStr;
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
    
}
- (void)sendTestCodeAction:(UIButton *)btn{
    [self requestSendResetPasswordMsg];
}

/**
 发送验证码接口
 */
- (void)requestSendResetPasswordMsg{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"phone":USERDEFAULT(@"mobilephone")
                          };
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.sms/reset-password-msg/send"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@, %@",request.responseObject, [request.responseObject objectForKey:@"msg"]);
        if ([[request.responseObject objectForKey:@"code"] integerValue] == 0 && [[request.responseObject objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"验证码发送成功!"];
            [self textNum];
        } else {
            [self showSVProgressHUDErrorWithStatus:[request.responseObject objectForKey:@"msg"]];
            
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseString);
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD  showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
-(void)showSVProgressHUDSuccessWithStatus:(NSString *)str{
    [SVProgressHUD  dismiss];
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumberAndZiMuWithString:string textField:textField range:range];
}
///只能输入数字和字母
- (BOOL)validateNumberAndZiMuWithString:(NSString *)string
                              textField:(UITextField *)textField
                                  range:(NSRange)range
{
    if (textField == _textfVerificationCode) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            //         48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48){
                
                return NO; // 48 unichar for 0
            }
            if (character > 57) {
                
                return NO; //
            }
            
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        
        if (proposedNewLength >= 4 + 1) {
            return NO;//限制长度
        }
        
        
    } else {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            //         48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48){
                
                return NO; // 48 unichar for 0
            }
            if (character > 57 && character < 65) {
                
                return NO; //
            }
            if (character == 32) {
                return NO;
            }
            
            if (character > 90 && character < 97){
                
                return NO;
            }
            if (character > 122) {
                
                return NO;
            }
            
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        
        
        if (proposedNewLength >= 20 + 1) {
            return NO;//限制长度
        }
        
    }
    
    
    return YES;
}
#pragma mark - 倒计时 button
- (void)textNum{
    __weak typeof(self) bself = self;
    __block int timeout = 60; //倒计时时间
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    bself._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,self.queue);
    dispatch_source_set_timer(bself._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(bself._timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(bself._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [bself.buttonSendTestCode setTitle:@"重新发送" forState:UIControlStateNormal];
                bself.buttonSendTestCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            if (seconds == 0) {
                seconds = 60;
            }
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [bself.buttonSendTestCode setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                bself.buttonSendTestCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(bself._timer);
}
- (void)textFieldDidChangeNotification:(NSNotification *)notify
{
    if ([self isJudgementClick]) {
        [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
        btnSubmit.userInteractionEnabled = YES;
    } else {
        [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xDDDDDD).CGColor,(id)HEXCOLOR(0xDDDDDD).CGColor]];
        [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
        btnSubmit.userInteractionEnabled = NO;
    }
}
#pragma mark - 判断是否放开保存页面
- (BOOL)isJudgementClick{
    if (_textfVerificationCode.text.length >= 4 && _textfNewSerceCode.text.length >= 8) {
        return YES;
    } else {
        return NO;
    }
}
//判断是否是纯数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
- (void)btnSubmitAction{
    BOOL judge = [HFUntilTool judgePassWordLegal: _textfNewSerceCode.text];
    if (!judge) {
        [SVProgressHUD showErrorWithStatus:@"密码应为8~20位且包含字母和数字!"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        if (self.block) {
            self.block();
        }
    }
}
@end
