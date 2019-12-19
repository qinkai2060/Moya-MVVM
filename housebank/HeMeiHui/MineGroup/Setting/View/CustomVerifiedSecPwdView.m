//
//  CustomVerifiedSecPwdView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomVerifiedSecPwdView.h"
#import "UIView+addGradientLayer.h"
#define FitiPhone6Scale(x) ((x) * ScreenW / 375.0f)

@interface CustomVerifiedSecPwdView()<UITextFieldDelegate>
{
    UITextField *_textfOriginal;
}
@end

@implementation CustomVerifiedSecPwdView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

+(instancetype)showCustomVerifiedSecPwdViewIn:(UIView *)view forgetblock:(void(^)())forgetblock sureblock:(void(^)(NSString *password))sureblock closeblock:(void(^)())closeblock{
    CustomVerifiedSecPwdView *cus = [[CustomVerifiedSecPwdView alloc] initWithFrame:view.bounds];
    cus.sureblock = sureblock;
    cus.closeblock = closeblock;
    cus.forgetblock = forgetblock;
      [view addSubview:cus];
    return cus;
}



- (void)btnCloseUpInsideAction{
    [_textfOriginal resignFirstResponder];

    if (self.closeblock) {
        self.closeblock();
        [self removeFromSuperview];
    }
    
}
- (void)btnSureUpInsideAction{
    [_textfOriginal resignFirstResponder];
//    if (![HFUntilTool judgePassWordLegal:_textfOriginal.text] ) {
//        [SVProgressHUD showErrorWithStatus: @"密码应为8-20位字母数字组合!"];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD dismissWithDelay:1.0];
//        return ;
//    }
    if (!_textfOriginal.text.length) {
        [SVProgressHUD showErrorWithStatus: @"请输入二级密码!"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        return ;
    }
    if (self.sureblock) {
        self.sureblock(_textfOriginal.text);
        [self removeFromSuperview];
    }
}
- (void)btnForgetUpInsideAction{
    [_textfOriginal resignFirstResponder];

    if (self.forgetblock) {
        self.forgetblock();
        [self removeFromSuperview];

    }
}
- (void)createView{
    UIView * viewB = [[UIView alloc] initWithFrame:self.bounds];
    viewB.backgroundColor = [UIColor blackColor];
    viewB.alpha = 0.4;
    [self addSubview:viewB];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor =  [UIColor whiteColor];
    view.layer.cornerRadius = FitiPhone6Scale(10);
    view.frame = CGRectMake(0, FitiPhone6Scale(230), FitiPhone6Scale(280), FitiPhone6Scale(170));
    view.centerX = self.center.x;
    [self addSubview:view];

    UIView *viewbg = [[UIView alloc] initWithFrame:CGRectMake(FitiPhone6Scale(25), FitiPhone6Scale(30), FitiPhone6Scale(230), FitiPhone6Scale(45))];
    viewbg.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
    viewbg.layer.borderWidth = 0.8;
    viewbg.layer.cornerRadius = FitiPhone6Scale(5);
    viewbg.layer.masksToBounds = YES;
    [view addSubview:viewbg];
    
    _textfOriginal = [[UITextField alloc] initWithFrame:CGRectMake(FitiPhone6Scale(40), FitiPhone6Scale(30), FitiPhone6Scale(200), FitiPhone6Scale(45))];
    _textfOriginal.placeholder = @"请输入二级密码";
    _textfOriginal.delegate = self;
    _textfOriginal.secureTextEntry = YES;
    _textfOriginal.textAlignment = NSTextAlignmentLeft;
    [_textfOriginal setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfOriginal.font = PFR14Font;
    [view addSubview:_textfOriginal];
    [_textfOriginal becomeFirstResponder];
    UIButton * btnforget = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnforget setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    btnforget.titleLabel.font = PFR14Font;
    [btnforget setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
    [btnforget addTarget:self action:@selector(btnForgetUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnforget.backgroundColor = [UIColor whiteColor];
    [view addSubview:btnforget];
    btnforget.frame = CGRectMake(FitiPhone6Scale(185), MaxY(_textfOriginal) + FitiPhone6Scale(12), FitiPhone6Scale(70), FitiPhone6Scale(20));
    
    
    UIButton * btnclose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnclose setTitle:@"取消" forState:(UIControlStateNormal)];
    btnclose.titleLabel.font = PFR16Font;
    [btnclose setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    [btnclose addTarget:self action:@selector(btnCloseUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnclose.backgroundColor = [UIColor whiteColor];
    [view addSubview:btnclose];
    btnclose.frame = CGRectMake(0, FitiPhone6Scale(125), FitiPhone6Scale(140), FitiPhone6Scale(45));
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, FitiPhone6Scale(125), FitiPhone6Scale(140), 0.8)];
    line.backgroundColor = HEXCOLOR(0xE5E5E5);
    [view addSubview:line];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btnclose.bounds byRoundingCorners:UIRectCornerBottomLeft  cornerRadii:CGSizeMake(FitiPhone6Scale(10), FitiPhone6Scale(10))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btnclose.bounds;
    maskLayer.path = maskPath.CGPath;
    btnclose.layer.mask = maskLayer;
    
    
    UIButton * btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSure setTitle:@"确定" forState:(UIControlStateNormal)];
    btnSure.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnSure addTarget:self action:@selector(btnSureUpInsideAction) forControlEvents:(UIControlEventTouchUpInside)];
    btnSure.backgroundColor = HEXCOLOR(0xFF2E5D);
    [view addSubview:btnSure];
    btnSure.frame = CGRectMake(FitiPhone6Scale(140), FitiPhone6Scale(125), FitiPhone6Scale(140), FitiPhone6Scale(45));
    [btnSure addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSure bringSubviewToFront:btnSure.titleLabel];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:btnSure.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(FitiPhone6Scale(10), FitiPhone6Scale(10))];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = btnSure.bounds;
    maskLayer2.path = maskPath2.CGPath;
    btnSure.layer.mask = maskLayer2;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumberAndZiMuWithString:string textField:textField range:range];
}

///只能输入数字和字母
- (BOOL)validateNumberAndZiMuWithString:(NSString *)string
                              textField:(UITextField *)textField
                                  range:(NSRange)range
{
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48){
            
            return NO; // 48 unichar for 0
        }
        if (character > 57 && character < 65) {
            
            return NO; //
        }
        if (character == 32) {// 空格
            return NO;
        }
        if (character > 90 && character < 97){
            
            return NO;
        }
        if (character > 122) {
            
            return NO;
        }
        
    }
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength >= 20 + 1) {
        return NO;//限制长度
    }
    return YES;
}

@end
