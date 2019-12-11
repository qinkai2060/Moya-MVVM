//
//  WARSignatureViewController.m
//  Pods
//
//  Created by huange on 2017/8/16.
//
//

#import "WARSignatureViewController.h"
#import "WARProgressHUD.h"

#import "UIImage+Color.h"
#import "UIImage+WARBundleImage.h"

#define textViewMargin 15
#define textViewMarginTop 15
#define textViewHeight 100

@interface WARSignatureViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, copy) NSString *placeholderString;
@property (nonatomic, strong) UILabel *textLengthLabel;

@end

@implementation WARSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [WARUserEditDataManager new];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    
    self.placeholderString = WARLocalizedString(@"请填写签名");
    self.title = WARLocalizedString(@"签名");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self createTextView];
//    [self createButton];
    [self createDisPlayCountLabel];
    
    self.rightButtonText = WARLocalizedString(@"保存");
    self.navigationBarClear = NO;
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
    self.textview.layer.cornerRadius = 5;
    self.textview.delegate = self;
    self.textview.text = self.placeholderString;
    self.textview.backgroundColor = HEXCOLOR(0xf4f4f4);
    self.textview.font = [UIFont systemFontOfSize:16];
    self.textview.textColor = HEXCOLOR(0x999999);
    self.textview.text = self.dataManager.user.signature;
        
    [self.textview becomeFirstResponder];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = self.placeholderString;
        textView.textColor = HEXCOLOR(0x999999);
        self.textLengthLabel.text = @"0/50";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:self.placeholderString]){
        textView.text=@"";
        textView.textColor = HEXCOLOR(0x333333);
        self.textLengthLabel.text = @"0/50";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 50) {
        NSRange textRange = NSMakeRange(0, 50);
        textView.text = [textView.text substringWithRange:textRange];
    }
    
    if(![textView.text isEqualToString:self.placeholderString]){
        self.textLengthLabel.text = [NSString stringWithFormat:@"%ld/50",textView.text.length];
    }
    
    if ([self.textview.text isEqualToString:self.placeholderString] || [self.textview.text isEqualToString:self.dataManager.user.signature]) {
        self.valueChanged = NO;
    }else {
        self.valueChanged = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if([text isEqualToString:@"\b"]){
//        return YES;
//    }else if([[textView text] length] > 49){
//        
//        return NO;
//    }
    
//    if([[textView text] length] > 49){
//        
//        return NO;
//    }
    
    return YES;
}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 22.0;
    button.clipsToBounds = YES;
    [button setTitle:WARLocalizedString(@"提交") forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:RGB(0,216,183)] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFont(15);
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
//            [self rightButtonAction];
            
        }
        
        return [RACSignal empty];
    }];
}


- (void)createDisPlayCountLabel {
    self.textLengthLabel = [UILabel new];
    self.textLengthLabel.textAlignment = NSTextAlignmentRight;
    self.textLengthLabel.textColor = HEXCOLOR(0x999999);
    self.textLengthLabel.font = [UIFont systemFontOfSize:16];
    self.textLengthLabel.text = [NSString stringWithFormat:@"%ld/50",self.textview.text.length];
    [self.view addSubview:self.textLengthLabel];
    
    [self.textLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textview.mas_bottom).with.offset(5);
        make.leading.trailing.equalTo(self.textview);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)rightButtonAction {
    [MBProgressHUD showLoad];
    
    [self.dataManager changeSignatureWithString:self.textview.text successBlock:^(id successData) {
        [MBProgressHUD hideHUD];
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
        [self.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
    }];
}

@end
