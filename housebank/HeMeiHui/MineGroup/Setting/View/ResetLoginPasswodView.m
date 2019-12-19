//
//  ResetLoginPasswodView.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ResetLoginPasswodView.h"
#import "UIView+addGradientLayer.h"
@interface ResetLoginPasswodView()<UITextFieldDelegate>
{
    UIButton *btnSubmit;
}

@end

@implementation ResetLoginPasswodView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(165);
    }];
    
    UILabel *OriginalPW = [[UILabel alloc] init];
    OriginalPW.text = @"原密码";
    OriginalPW.textColor = HEXCOLOR(0x333333);
    OriginalPW.font = PFR14Font;
    [self addSubview:OriginalPW];
    [OriginalPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfOriginal = [[UITextField alloc] init];
    _textfOriginal.placeholder = @"请输入原密码";
    _textfOriginal.delegate = self;
    _textfOriginal.secureTextEntry = YES;
    _textfOriginal.textAlignment = NSTextAlignmentRight;
    [_textfOriginal setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfOriginal.font = PFR14Font;
    [self addSubview:_textfOriginal];
    [_textfOriginal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.left.equalTo(OriginalPW.mas_right).offset(10);
        make.height.mas_equalTo(55);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OriginalPW);
        make.right.equalTo(self);
        make.top.equalTo(OriginalPW.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    
    
    UILabel *newPW = [[UILabel alloc] init];
    newPW.text = @"新密码";
    newPW.textColor = HEXCOLOR(0x333333);
    newPW.font = PFR14Font;
    [self addSubview:newPW];
    [newPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(line1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfNew = [[UITextField alloc] init];
    _textfNew.placeholder = @"请输入新密码";
    _textfNew.delegate = self;
    _textfNew.secureTextEntry = YES;
    _textfNew.textAlignment = NSTextAlignmentRight;
    [_textfNew setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfNew.font = PFR14Font;
    [self addSubview:_textfNew];
    [_textfNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(newPW);
        make.left.equalTo(newPW.mas_right).offset(10);
        make.height.mas_equalTo(55);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPW);
        make.right.equalTo(self);
        make.top.equalTo(newPW.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    
    UILabel *newAgainPW = [[UILabel alloc] init];
    newAgainPW.text = @"确认密码";
    newAgainPW.textColor = HEXCOLOR(0x333333);
    newAgainPW.font = PFR14Font;
    [self addSubview:newAgainPW];
    [newAgainPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(line2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfNewAgain = [[UITextField alloc] init];
    _textfNewAgain.placeholder = @"请再次输入新密码";
    _textfNewAgain.delegate = self;
    _textfNewAgain.secureTextEntry = YES;
    _textfNewAgain.textAlignment = NSTextAlignmentRight;
    [_textfNewAgain setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfNewAgain.font = PFR14Font;
    [self addSubview:_textfNewAgain];
    [_textfNewAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(newAgainPW);
        make.left.equalTo(newAgainPW.mas_right).offset(10);
        make.height.mas_equalTo(55);
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
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumberAndZiMuWithString:string textField:textField range:range];
}
- (void)textFieldDidChangeNotification:(NSNotification *)notify
{
    [self isJudgementSubmit];
    
}
- (BOOL)isJudgementSubmit{
    if (_textfOriginal.text.length >= 1 && _textfOriginal.text.length <= 20 && _textfNew.text.length >= 8 && _textfNew.text.length <= 20 &&
        _textfNewAgain.text.length >= 8 && _textfNewAgain.text.length <= 20) {
        btnSubmit.userInteractionEnabled = YES;
        [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
        return YES;
        
        
    } else {
        btnSubmit.userInteractionEnabled = NO;
        [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xDDDDDD).CGColor,(id)HEXCOLOR(0xDDDDDD).CGColor]];
        [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
        
        return NO;
    }
    
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
        if (character > 90 && character < 97) {
            
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
- (void)btnSubmitAction{
    
    if (![_textfNewAgain.text isEqualToString:_textfNew.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次新密码不一致!"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (![HFUntilTool judgePassWordLegal: _textfNewAgain.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码应为8~20位且包含字母和数字!"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    if (self.sureBlock) {
        self.sureBlock();
    }
}
@end
