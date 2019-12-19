//
//  SuggestionBoxViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "SuggestionBoxViewController.h"
#import "UIView+addGradientLayer.h"
@interface SuggestionBoxViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textf;
@end

@implementation SuggestionBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见箱";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (void)setUI{
    
    UILabel *yourIdea = [[UILabel alloc] init];
    yourIdea.text = @"您的意见:";
    yourIdea.textColor = HEXCOLOR(0x333333);
    yourIdea.font = PFR14Font;
    [self.view addSubview:yourIdea];
    [yourIdea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 15));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yourIdea.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(yourIdea).offset(- 8);
        make.height.mas_equalTo(68);
    }];
    
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入您的意见";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = HEXCOLOR(0xCCCCCC);
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    
    // same font
    _textView.font = [UIFont systemFontOfSize:14.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    
    [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(90);
        make.height.mas_equalTo(0.8);
    }];
    
    
    UILabel *ContactInformation = [[UILabel alloc] init];
    ContactInformation.text = @"联系方式:";
    ContactInformation.textColor = HEXCOLOR(0x333333);
    ContactInformation.font = PFR14Font;
    [self.view addSubview:ContactInformation];
    [ContactInformation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(line).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 15));
    }];
    
    
    _textf = [[UITextField alloc] init];
    _textf.placeholder = @"邮箱或手机号码";
    _textf.delegate = self;
    [_textf setValue:HEXCOLOR(0xCCCCCC) forKeyPath:@"placeholderLabel.textColor"];
    _textf.font = PFR14Font;
    [self.view addSubview:_textf];
    [_textf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textView);
        make.top.equalTo(ContactInformation);
        make.right.equalTo(_textView);
        make.height.equalTo(ContactInformation);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(line.mas_bottom).offset(45);
        make.height.mas_equalTo(0.8);
    }];
    
    
    UIButton *btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSubmit setTitle:@"提交意见" forState:(UIControlStateNormal)];
    btnSubmit.titleLabel.font = PFR16Font;
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSubmit.layer.cornerRadius = 20;
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.backgroundColor = HEXCOLOR(0xFF2E5D);
    [btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(63);
        make.right.equalTo(self.view).offset(-63);
        make.height.mas_equalTo(40);
        
    }];
    [self.view layoutIfNeeded];
    [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
}

/**
 提交方法
 */
- (void)btnSubmitAction{
    NSLog(@"提交");
    if (!_textView.text.length) {
        [self showSVProgressHUDErrorWithStatus:@"请输入您的意见!"];
    } else if (![HFUntilTool validateContactNumber:_textf.text] && ![HFUntilTool isValidateEmail:_textf.text]) {
        [self showSVProgressHUDErrorWithStatus:@"手机或邮箱格式不正确!"];
    } else {
        [self requestSaveSuggestion];
    }
}
- (void)requestSaveSuggestion{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"userId":USERDEFAULT(@"uid"),
                          @"suggestionContent":_textView.text,
                          @"mobilePhone":_textf.text,
                          @"source": @"2"
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/user/saveSuggestion"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {

        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (CHECK_STRING_ISNULL(request.responseString)) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        NSInteger response = [request.responseString integerValue];

        switch (response) {
            case 1:
            {
                //已设置
                [self showSVProgressHUDSuccessWithStatus:@"提交成功"];
                [NSThread sleepForTimeInterval:1];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
                break;
            case 0:
            {
                //已设置
                [self showSVProgressHUDErrorWithStatus:@"提交失败,稍后再试!"];
                
            }
                break;
           
                
            default:
                [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];

                break;
        }
    }];
}
@end
