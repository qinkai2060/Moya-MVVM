//
//  EditTopContactsViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "EditTopContactsViewController.h"
#import "UIView+addGradientLayer.h"
@interface EditTopContactsViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textfName;
@property (nonatomic, strong) UITextField *textfPhone;

@end

@implementation EditTopContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.title = self.ntitle;

    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    
    UILabel *name = [[UILabel alloc] init];
    name.text = @"姓名";
    name.textColor = HEXCOLOR(0x333333);
    name.font = PFR14Font;
    [self.view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfName = [[UITextField alloc] init];
    _textfName.placeholder = @"请输入姓名";
    _textfName.text = self.model.name ?: @"";
    _textfName.delegate = self;
    _textfName.textAlignment = NSTextAlignmentRight;
    [_textfName setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfName.font = PFR14Font;
    [self.view addSubview:_textfName];
    [_textfName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view);
        make.left.equalTo(name.mas_right).offset(10);
        make.height.mas_equalTo(55);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.right.equalTo(self.view);
        make.top.equalTo(name.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"手机号";
    phone.textColor = HEXCOLOR(0x333333);
    phone.font = PFR14Font;
    [self.view addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(line1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    
    _textfPhone = [[UITextField alloc] init];
    _textfPhone.placeholder = @"请输入手机号";
    _textfPhone.text = self.model.phone ?: @"";
    _textfPhone.keyboardType = UIKeyboardTypeNumberPad;
    _textfPhone.delegate = self;
    _textfPhone.textAlignment = NSTextAlignmentRight;
    [_textfPhone setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textfPhone.font = PFR14Font;
    [self.view addSubview:_textfPhone];
    [_textfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(phone);
        make.left.equalTo(phone.mas_right).offset(10);
        make.height.mas_equalTo(55);
    }];
    
    
    UIButton *btnAddTopContacts = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnAddTopContacts setTitle:@"确认" forState:(UIControlStateNormal)];
    btnAddTopContacts.titleLabel.font = PFR16Font;
    [btnAddTopContacts setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnAddTopContacts.backgroundColor = HEXCOLOR(0xFF2E5D);
    [btnAddTopContacts addTarget:self action:@selector(btnAddTopContactsAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnAddTopContacts];
    [btnAddTopContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(((KIsiPhoneX) ? (-34.f) : (0)));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.view layoutIfNeeded];
    [btnAddTopContacts addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnAddTopContacts bringSubviewToFront:btnAddTopContacts.titleLabel];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumberAndZiMuWithString:string textField:textField range:range];
}
///只能输入数字和字母
- (BOOL)validateNumberAndZiMuWithString:(NSString *)string
                              textField:(UITextField *)textField
                                  range:(NSRange)range
{
    if (textField == _textfPhone) {
        
    
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
        
        if (proposedNewLength >= 11 + 1) {
            return NO;//限制长度
        }
        
        
    }
    
    
    
    return YES;
}
/**
 确认方法
 */
- (void)btnAddTopContactsAction{
    if (!self.textfName.text.length) {
        [self showSVProgressHUDErrorWithStatus:@"请输入姓名!"];
        return;
    }
    if ([HFUntilTool isValidateByRegex:self.textfPhone.text]) {
        [self requestAddContacts];
    } else {
        [self showSVProgressHUDErrorWithStatus:@"手机号格式不正确!"];
    }
    
}

/**
 添加修改联系人  添加无id 修改有id
 */
- (void)requestAddContacts{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSMutableDictionary *dic = [@{
                          @"sid":sid,
                          @"name":_textfName.text,
                          @"phone":_textfPhone.text
                          } mutableCopy];
    if ([self.title isEqualToString:@"编辑常用联系人"]) {
        [dic setObject:self.model.topContactsId forKey:@"id"];
    }
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/member/addContacts"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:[NSString stringWithFormat:@"%@成功!", self.ntitle]];
            [NSThread sleepForTimeInterval:1];
            if (self.refrenshBlock) {
                self.refrenshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
@end
