//
//  WARFaceSignatureViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/23.
//

#import "WARFaceSignatureViewController.h"
#import "WARProgressHUD.h"

#import "WARLocalizedHelper.h"

#import "UIImage+Color.h"
#import "UIImage+WARBundleImage.h"

#define textViewMargin 15
#define textViewMarginTop 15
#define textViewHeight 100

@interface WARFaceSignatureViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, copy) NSString *placeholderString;
@property (nonatomic, strong) UILabel *textLengthLabel;

@property (nonatomic, strong) WARGroupHomeModel *groupHomeModel;
@property (nonatomic, assign) TextType type;

@end

@implementation WARFaceSignatureViewController

- (id)initWithGroupHomeModel:(WARGroupHomeModel *)groupHomeModel title:(NSString *)title {
    self = [super init];
    if (self) {
        self.groupHomeModel = groupHomeModel;
        if ([title isEqualToString:WARLocalizedString(@"群介绍")]) {
            self.type = GroupDesType;
        }
        else if ([title isEqualToString:WARLocalizedString(@"群公告")]) {
            self.type = GroupNoticeType;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = SubTextBackgroundColor;
    [self initUI];
}


- (void)initUI {
    if (self.type == GroupDesType) {
        self.placeholderString = WARLocalizedString(@"请填写群介绍");
        self.title = WARLocalizedString(@"群介绍");
    }
    else if (self.type == GroupNoticeType) {
        self.placeholderString = WARLocalizedString(@"请填写群公告");
        self.title = WARLocalizedString(@"群公告");
    }
    else {
        self.placeholderString = WARLocalizedString(@"输入文字…");
        self.title = WARLocalizedString(@"个性签名");
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self createTextView];
    [self createDisPlayCountLabel];
    
//    self.rightButtonText = WARLocalizedString(@"保存");

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
    self.textview.backgroundColor = UIColorWhite;
    self.textview.font = [UIFont systemFontOfSize:16];
    self.textview.textColor = SubTextColor;
    if (self.type == GroupNoticeType) {
        self.textview.text = self.groupHomeModel.notice;
    }
    else if (self.type == GroupDesType) {
        self.textview.text = self.groupHomeModel.desc;
    }
    else {
        self.textview.text = self.currentFaceModel.signature;
    }
    
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
    
    if (self.type == GroupNoticeType) {
        if ([self.textview.text isEqualToString:self.placeholderString] || [self.textview.text isEqualToString:self.groupHomeModel.notice]) {
            self.valueChanged = NO;
        }else {
            self.valueChanged = YES;
        }
    }
    else if (self.type == GroupDesType) {
        if ([self.textview.text isEqualToString:self.placeholderString] || [self.textview.text isEqualToString:self.groupHomeModel.desc]) {
            self.valueChanged = NO;
        }else {
            self.valueChanged = YES;
        }
    }
    else {
        if ([self.textview.text isEqualToString:self.placeholderString] || [self.textview.text isEqualToString:self.currentFaceModel.signature]) {
            self.valueChanged = NO;
        }else {
            self.valueChanged = YES;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
    }
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
    self.textLengthLabel.textColor = DisabledTextColor;
    self.textLengthLabel.font = [UIFont systemFontOfSize:11];
    self.textLengthLabel.text = [NSString stringWithFormat:@"%ld/50",self.textview.text.length];
    [self.view addSubview:self.textLengthLabel];
    
    [self.textLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textview.mas_bottom).offset(-9);
        make.trailing.equalTo(self.textview).offset(-10);
        make.height.mas_equalTo(11);
    }];
    
}

- (void)backAction {
    if (self.type == GroupNoticeType) {
        if (self.groupDesBlock) {
            self.groupDesBlock(self.textview.text);
        }
    }
    else if (self.type == GroupDesType) {
        if (self.groupDesBlock) {
            self.groupDesBlock(self.textview.text);
        }
    }
    else {
        if (![self.currentFaceModel.signature isEqualToString:self.textview.text]) {
            self.currentFaceModel.signature = self.textview.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WARFaceManagerValueChanged" object:nil];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
