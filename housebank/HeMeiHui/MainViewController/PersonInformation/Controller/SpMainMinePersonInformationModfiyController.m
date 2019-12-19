//
//  SpMainMinePersonInformationModfiyController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpMainMinePersonInformationModfiyController.h"
#import "PersonInformationInputView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PersonInformationCancelSureView.h"
#import "PersonSignalViewModel.h"
@interface SpMainMinePersonInformationModfiyController()

@property (nonatomic,strong)PersonInformationInputView *inputView;

@property (nonatomic, strong) UIView * backGroundView;

@property (nonatomic, strong) UITextField *codeTF; // 验证码

@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,strong)PersonInformationCancelSureView *cancelSureView;

@property (nonatomic, strong) PersonSignalViewModel * viewModel;

@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, strong) dispatch_source_t _timer;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation SpMainMinePersonInformationModfiyController

- (PersonInformationCancelSureView *)cancelSureView {
    if (_cancelSureView == nil) {
        _cancelSureView = [PersonInformationCancelSureView new];
        [self.view addSubview:_cancelSureView];
        _cancelSureView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, WScale(40));
    }
    return _cancelSureView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setKeyboardType];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    __weak SpMainMinePersonInformationModfiyController *weakSelf = self;
    
    self.cancelSureView.cancelBlock = ^{
        
        [weakSelf cancelSureBtn];
    };
    
    self.cancelSureView.sureBlock = ^{
        
        [weakSelf cancelSureBtn];
    };
}

- (void)initNotification {
    //监听键盘弹出或收回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUITextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.inputView];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)cancelSureBtn {
    [self.inputView cancelKeyboard];
}

- (void)keyboardChange:(NSNotification *)note{
    
    //拿到键盘弹出的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘弹出所需时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (frame.origin.y >= SCREEN_HEIGHT) {
        
        //添加输入框弹出和收回动画
        [UIView animateWithDuration:duration animations:^{
            self.cancelSureView.y = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {

        }];
        return;
    }
    
    //添加输入框弹出和收回动画
    [UIView animateWithDuration:duration animations:^{
        self.cancelSureView.y = frame.origin.y - self.cancelSureView.height;
    }];
}

- (void)setSubView {
    [super setSubView];
    
    
    self.nvTitle = [self.nvTitle stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    //输入View
    PersonInformationInputView *inputView = [PersonInformationInputView new];
    self.inputView = inputView;
    [self.contentView addSubview:inputView];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
    }];
    
    //保存View
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nvView addSubview:saveBtn];
    self.saveBtn = saveBtn;
    saveBtn.frame = CGRectMake(SCREEN_WIDTH - WScale(40), STATUSBAR_HEIGHT, WScale(40), NAVBAR_HEIGHT);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:WScale(13)]];
    [saveBtn addTarget:self action:@selector(actionSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    if (self.currentType == PersonInformationType_ContactPhone) {
         [self.view addSubview:self.backGroundView];
         self.backGroundView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
         [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.leading.trailing.mas_equalTo(self.contentView);
             make.top.equalTo(self.inputView.mas_bottom).offset(5);
             make.height.equalTo(@(50));
        }];
        
        [self.backGroundView addSubview:self.codeTF];
        [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backGroundView);
            make.left.equalTo(self.backGroundView).offset(20);
            make.width.equalTo(@200);
        }];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.layer.masksToBounds = YES;
        self.sureBtn.layer.cornerRadius = 20;
        self.sureBtn.titleLabel.font = kFONT(15);
        self.sureBtn.backgroundColor = RGBACOLOR(99, 199, 232, 1);
        [self.backGroundView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backGroundView).offset(5);
            make.bottom.equalTo(self.backGroundView).offset(-5);
            make.right.equalTo(self.backGroundView).offset(-5);
            make.width.equalTo(@100);
        }];
        
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[self.viewModel getIphoneToSendWithNumber:self.inputView.textMessage areacode:@"+86"]subscribeNext:^(NSDictionary * x) {
                if ([[x objectForKey:@"code"] integerValue] == 0 && [[x objectForKey:@"state"] integerValue] == 1) {
                    [self showSVProgressHUDSuccessWithStatus:@"验证码发送成功!"];
                    [self textNum];
                } else {
                    [self showSVProgressHUDErrorWithStatus:[x objectForKey:@"msg"]];
                    
                }
            }];
        }];
    }
   
    
    
}



/**
 Save 点击事件
 */
- (void)actionSaveBtn:(UIButton *)sender {
    
    if (self.inputView.textMessage.length <= 0 ) {
        return;
    }
    
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary * params ;
    switch (self.currentType) {
        case PersonInformationType_NickName:
            params = @{@"nickname":self.inputView.textMessage,
                       @"sid":sid
                       };
            break;
        case PersonInformationType_Head:
            params = @{@"head_url":self.inputView.textMessage,
                       @"sid":sid
                       };
            break;
        case PersonInformationType_Name:
            params = @{@"name":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_Sex:
            params = @{@"gender":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_ContactPhone:
            params = @{@"mobilephone":self.inputView.textMessage,
                       @"code":objectOrEmptyStr(self.codeTF.text),
                        @"sid":sid
                       };
            break;
        case PersonInformationType_RefillPhone:
            params = @{@"telphone":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_Email:
            params = @{@"email":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_Address:
            params = @{@"selfAdress":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_IDNumber:
            params = @{@"identity":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_IDPicture:
            params = @{@"identity":self.inputView.textMessage,
                        @"sid":sid
                       };
            break;
        case PersonInformationType_BankNubmer:
        
            break;
            
        default:
            break;
    }
    @weakify(self);
    
    [[self.viewModel changePersonIndoWithParams:params]subscribeNext:^(NSDictionary * x) {
        @strongify(self);
        NSNumber * code = [x objectForKey:@"code"];
        if ([code isEqual:@0]) {
            //这里需要进行请求
            if (self.success) {
                self.success(self.inputView.textMessage);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }else {
            NSString *error = [x objectForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(error)];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //TODO: 页面appear 禁用
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)setKeyboardType {
    
    switch (self.currentType) {
        case PersonInformationType_Head:
        {
            
            break;
        }
        case PersonInformationType_Name:
        {
            self.inputView.keyboardType = UIKeyboardTypeDefault;
            break;
        }
        case PersonInformationType_Sex:
        {
            self.inputView.keyboardType = UIKeyboardTypeDefault;
            break;
        }
        case PersonInformationType_ContactPhone:
        {
            self.inputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case PersonInformationType_RefillPhone:
        {
            self.inputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case PersonInformationType_Email:
        {
            self.inputView.keyboardType = UIKeyboardTypeDefault;
            break;
        }
        case PersonInformationType_Address:
        {
            self.inputView.keyboardType = UIKeyboardTypeDefault;
            break;
        }
        case PersonInformationType_IDNumber:
        {
            self.inputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case PersonInformationType_IDPicture:
        {
            
            break;
        }
        case PersonInformationType_BankNubmer:
        {
            self.inputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
          
        default:
            break;
    }
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
                [bself.sureBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                bself.sureBtn.userInteractionEnabled = YES;
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
                [bself.sureBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                bself.sureBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(bself._timer);
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

- (PersonSignalViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PersonSignalViewModel alloc]init];
    }
    return _viewModel;
}
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [UIView new];
    }
    return  _backGroundView;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[UITextField alloc]init];
        _codeTF.placeholder = @"请输入验证码";
        _codeTF.borderStyle = UITextBorderStyleNone;
        _codeTF.font = kFONT(15);
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTF;
}
@end
