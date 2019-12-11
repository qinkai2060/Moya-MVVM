//
//  WARInputCollectionViewCell.m
//  Pods
//
//  Created by huange on 2017/9/5.
//
//

#import "WARInputCollectionViewCell.h"

#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "ReactiveObjC.h"

@implementation WARInputCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    [self createTextFeild];
    [self createButtomLine];
}

- (void)createTextFeild {
//    self.contentView.backgroundColor = [UIColor greenColor];
    self.inputTextField = [[UITextField alloc] init];
    self.inputTextField.font = [UIFont systemFontOfSize:16];
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inputTextField.textColor = COLOR_WORD_GRAY_3;
    self.inputTextField.placeholder = WARLocalizedString(@"添加个性标签（限15个字）");
    [self.contentView addSubview:self.inputTextField];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.height.equalTo(self.contentView);
    }];
    
    @weakify(self);
    [self.inputTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length > 15) {
            self.inputTextField.text = [x substringToIndex:15];
        }
    }];
}

- (void)createButtomLine {
    UIView *topLine = [UIView new];
    topLine.backgroundColor = HEXCOLOR(0xEEEDED);
    [self addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-1);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
}

@end
