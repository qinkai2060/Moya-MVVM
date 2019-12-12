//
//  WARFeedbackViewController.m
//  Pods
//
//  Created by huange on 2017/8/16.
//
//

#import "WARFeedbackViewController.h"
#import "WARSettingDataManager.h"
#import "WARProgressHUD.h"

#import "UIImage+Color.h"
#import "UIImage+WARBundleImage.h"

#define textViewMargin 15
#define textViewMarginTop 15
#define textViewHeight 180

@interface WARFeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, copy) NSString *placeholderString;

@end

@implementation WARFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.placeholderString = WARLocalizedString(@"请输入您的反馈意见，已帮助我们改进(字数1000字以内）");
    self.title = WARLocalizedString(@"意见反馈");
    self.view.backgroundColor = HEXCOLOR(0xf4f4f4);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTextView];
    [self createButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.textview resignFirstResponder];
}

- (void)createTextView {
    if (self.textview) {
        [self.textview removeFromSuperview];
    }
    self.textview = [UITextView new];
    [self.view addSubview:self.textview];
    
    CGSize textViewSize = CGSizeMake(self.view.frame.size.width - textViewMargin*2, textViewHeight);
    self.textview.textContainerInset = UIEdgeInsetsMake(textViewMargin, textViewMargin, textViewMargin, textViewMargin);
    self.textview.frame = CGRectMake(textViewMargin, textViewMarginTop, textViewSize.width, textViewSize.height);
    self.textview.layer.cornerRadius = 4;
    self.textview.delegate = self;
    self.textview.text = self.placeholderString;
    self.textview.backgroundColor = HEXCOLOR(0xffffff);
    self.textview.font = [UIFont systemFontOfSize:15];
    self.textview.textColor = HEXCOLOR(0xcccccc);

    if (@available(iOS 11.0, *)) {
        self.textview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = self.placeholderString;
        textView.textColor = HEXCOLOR(0xcccccc);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:self.placeholderString]){
        textView.text=@"";
        textView.textColor = HEXCOLOR(0x333333);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
    }
}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0;
    button.clipsToBounds = YES;
    [button setTitle:WARLocalizedString(@"提交") forState:UIControlStateNormal];
    [button setBackgroundColor:ThemeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFont(17);
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).with.offset(15);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-15);
        make.top.equalTo(self.textview.mas_bottom).with.offset(15);
        make.height.mas_equalTo(44);
    }];
    
    
    @weakify(self);
    RACSignal *enableSignal = [RACSignal combineLatest:@[self.textview.rac_textSignal] reduce:^id _Nullable{
        @strongify(self);
        
        if (self.textview.text.length > 0 && ![self.textview.text isEqualToString:self.placeholderString]) {
            return @(YES);
        }else {
            return @(NO);
        }
    }];
    
    button.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.textview isFirstResponder]) {
            [self.textview resignFirstResponder];
        }
        
        if (self.textview.text && self.textview.text.length > 0  && ![self.textview.text isEqualToString:self.placeholderString]) {
            [self sendRespondToServer];
        }
        
        return [RACSignal empty];
    }];
}


- (void)sendRespondToServer {
    WARSettingDataManager *manager = [WARSettingDataManager new];
    
    [MBProgressHUD showLoad];
    [manager feedbackWithText:self.textview.text Success:^(id successData) {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showAutoMessage:WARLocalizedString(@"感谢你的反馈")];
    } failed:^(id failedData) {
        [MBProgressHUD hideHUD];
    }];
}

@end
