//
//  WARUserInfoCreateNewTagViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserInfoCreateNewTagViewController.h"

#import "WARFaceManagerViewController.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARProgressHUD.h"

@interface WARUserInfoCreateNewTagViewController ()
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) UserInfoCreateNewTagViewControllerType type;
@end

@implementation WARUserInfoCreateNewTagViewController

- (instancetype)initWithType:(UserInfoCreateNewTagViewControllerType)type{
    if (self = [super init]) {
        self.type = type;
        switch (type) {
            case UserInfoCreateNewTagViewControllerTypeOfHometown:
                {
                    
                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfIndustry:
                {
                    self.title = WARLocalizedString(@"行业");
                    self.textField.placeholder = WARLocalizedString(@"请输入标签");
                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfWork:
                {
                    self.title = WARLocalizedString(@"职业");
                    self.textField.placeholder = WARLocalizedString(@"请输入标签");
                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfCompany:
                {
                    self.title = WARLocalizedString(@"添加公司");
                    self.textField.placeholder = WARLocalizedString(@"请输入所在公司的名称");
                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfFood:
                {
                    self.title = WARLocalizedString(@"美食");
                    self.textField.placeholder = WARLocalizedString(@"创建美食标签");
                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfSports:
                {
                    self.title = WARLocalizedString(@"运动");
                    self.textField.placeholder = WARLocalizedString(@"创建运动标签");

                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfTravel:
                {
                    self.title = WARLocalizedString(@"旅游");
                    self.textField.placeholder = WARLocalizedString(@"创建旅游标签");

                }
                break;
            case UserInfoCreateNewTagViewControllerTypeOfOther:
            {
                self.title = WARLocalizedString(@"其他");
                self.textField.placeholder = WARLocalizedString(@"请输入标签");
            }
            default:
                break;
        }
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rightButtonText = WARLocalizedString(@"添加");
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)initUI{
    
    self.view.backgroundColor = kColor(whiteColor);
    
    [self.view addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(25);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = COLOR_WORD_GRAY_E;
    [self.view addSubview:lineV];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(11);
        make.left.right.equalTo(self.textField);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)rightButtonAction{
    if (self.textField.text.length) {
        if (self.textField.text.length > 10) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"最多10个字")];
            return;
        }
        
        if (self.addBlock) {
            self.addBlock(self.textField.text);
        }
        if (self.type == UserInfoCreateNewTagViewControllerTypeOfIndustry || self.type == UserInfoCreateNewTagViewControllerTypeOfWork) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WARFaceManagerViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }else{
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"请输入信息")];
    }
    
}

#pragma mark - getter methods
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
