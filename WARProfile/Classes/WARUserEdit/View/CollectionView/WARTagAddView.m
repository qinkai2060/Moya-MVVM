//
//  WARTagAddView.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARTagAddView.h"

@implementation WARTagAddView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    [self createTopLine];
    [self createAddButton];
    [self createTextField];
    [self createTitleLabel];
}

- (void)createTopLine {
    self.topLine = [UIView new];
    self.topLine.backgroundColor = HEXCOLOR(0xEEEDED);
    [self addSubview:self.topLine];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

- (void)createTextField {
    self.inputTextField = [[UITextField alloc] init];
    UIImage *backImage =  [UIImage war_imageName:@"label_background" curClass:[self class] curBundle:@"WARUserEdit.bundle"];
    self.inputTextField.background = backImage;
    self.inputTextField.font = [UIFont systemFontOfSize:14];
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.frame = CGRectMake(0, 0, 20, 45);
    self.inputTextField.leftView = leftView;
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inputTextField.textColor = COLOR_WORD_GRAY_3;
    self.inputTextField.placeholder = WARLocalizedString(@"添加个性标签（限15个字）");
    [self addSubview:self.inputTextField];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.right.equalTo(self.addButton.mas_left).with.offset(-15);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(45);
    }];
    
    @weakify(self);
    [self.inputTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length > 15) {
            self.inputTextField.text = [x substringToIndex:15];
        }
    }];
}

- (void)createAddButton {
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitleColor:RGB(0,216,183) forState:UIControlStateNormal];
    [self.addButton setTitle:WARLocalizedString(@"添加") forState:UIControlStateNormal];
    
    @weakify(self);
    self.addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonAction:)]) {
            [self.delegate addButtonAction:self.inputTextField.text];
            self.inputTextField.text = @"";
        }
        
        return [RACSignal empty];
    }];

    
    [self addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(40);
    }];
}

- (void)createTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = COLOR_WORD_GRAY_3;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).with.offset(15);
        make.trailing.equalTo(self.mas_trailing).with.offset(-15);
        make.top.equalTo(self.inputTextField.mas_bottom).with.offset(15);
        make.height.mas_equalTo(20);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputTextField resignFirstResponder];
}

@end
