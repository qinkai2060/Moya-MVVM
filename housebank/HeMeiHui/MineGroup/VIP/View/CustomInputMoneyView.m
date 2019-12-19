//
//  CustomInputMoneyView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomInputMoneyView.h"
#import "UIView+addGradientLayer.h"
#define myDotNumbers   @"0123456789.\n"
#define myNumbers      @"0123456789\n" 
@interface CustomInputMoneyView ()<UITextFieldDelegate>
{
    UIView *bgViewt;
}
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextField *inputMoney;

@end
@implementation CustomInputMoneyView

+(instancetype)CustomInputMoneyViewIn:(UIView *)view sureblock:(void(^)(float money))sureblock closeblock:(void(^)())closeblock{
    CustomInputMoneyView *cus = [[CustomInputMoneyView alloc] initWithFrame:view.bounds];
    cus.closeblock = closeblock;
    cus.sureblock = sureblock;
    [view addSubview:cus];
    return cus;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    bgViewt = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, self.width, self.height)];
    bgViewt.backgroundColor = [UIColor clearColor];
    [self addSubview:bgViewt];
    
    self.title = [[UILabel alloc] init];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont systemFontOfSize:16];
    self.title.textColor = HEXCOLOR(0x333333);
    self.title.text = @"分享设置";
    self.title.backgroundColor = [UIColor whiteColor];
    [bgViewt addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt).offset(-418);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(50);
        
    }];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [bgViewt addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt).offset(-50);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(368);
    }];
    
    UILabel *addMoney = [[UILabel alloc] init];
    addMoney.textAlignment = NSTextAlignmentCenter;
    addMoney.font = [UIFont systemFontOfSize:14];
    addMoney.textColor = HEXCOLOR(0x333333);
    addMoney.text = @"加价";
    addMoney.backgroundColor = [UIColor whiteColor];
    [bgViewt addSubview:addMoney];
    [addMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgViewt).offset(15);
        make.top.equalTo(self.title.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 55));
    }];
  
    self.inputMoney = [[UITextField alloc] init];
    self.inputMoney.placeholder = @"请输入您的零售价";
    self.inputMoney.font = [UIFont systemFontOfSize:14];
    self.inputMoney.keyboardType = UIKeyboardTypeDecimalPad;
    self.inputMoney.textColor = HEXCOLOR(0x333333);
    self.inputMoney.delegate = self;
    [bgViewt addSubview:self.inputMoney];
    [self.inputMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addMoney.mas_right).offset(20);
        make.top.equalTo(addMoney);
        make.size.mas_equalTo(CGSizeMake(200, 55));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [bgViewt addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgViewt).offset(15);
        make.right.equalTo(bgViewt).offset(-15);
        make.height.mas_equalTo(0.7);
        make.top.equalTo(addMoney.mas_bottom);
    }];
    
    UIButton *btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSure setTitle:@"完成" forState:(UIControlStateNormal)];
    btnSure.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSure.backgroundColor = HEXCOLOR(0xFF0000);
    [btnSure addTarget:self action:@selector(touchFinshAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bgViewt addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(50);
    }];
    
    [self layoutIfNeeded];
    
    [btnSure addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSure bringSubviewToFront:btnSure.titleLabel];
    
    UIView *tap = [[UIView alloc] init];
    [self addSubview:tap];
    [tap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.title.mas_top);
    }];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [tap addGestureRecognizer:tap1];
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = self.bounds;
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)      string {
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        
        // 判断字符串中是否有小数点，并且小数点不在第一位
        
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            
            /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= 9) {
                NSLog(@"单笔金额不能超过亿位");
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                return NO;
            }
        }else {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
        // 按cs分离出数组,数组按@""分离出字符串
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            
            NSLog(@"只能输入数字和小数点");
            
            return NO;
            
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            
            NSLog(@"小数点后最多两位");
            
            return NO;
        }
        if (textField.text.length > 11) {
            
            return NO;
            
        }
    }
    return YES;
}
- (void)touchAction{
    if (self.inputMoney.isFirstResponder) {
        [self.inputMoney resignFirstResponder];
    } else {
        [self removeViewAnimate];
    }
    if (self.closeblock) {
        self.closeblock();
    }
}
- (void)touchFinshAction{

    if (self.inputMoney.isFirstResponder) {
        [self.inputMoney resignFirstResponder];
    } else {
        [self removeViewAnimate];
    }
    if (self.sureblock) {
        self.sureblock(self.inputMoney.text.length > 0 ? [self.inputMoney.text floatValue] : 0.00);
    }
}
- (void)removeViewAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = CGRectMake(0, ScreenH, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
@end
