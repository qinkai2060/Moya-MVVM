//
//  HFEditingTagView.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFEditingTagView.h"
#import "HFAddressViewModel.h"

@interface HFEditingTagView ()
@property (nonatomic,strong) UITextField *tagTF;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) HFAddressViewModel *viewModel;
@property (nonatomic,assign) BOOL endEditing;
@end
@implementation HFEditingTagView

- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self addSubview:self.tagTF];
    [self addSubview:self.sureBtn];
    [self addSubview:self.tagLb];
    
}
- (void)hh_bindViewModel {
    [[self.tagTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if (x.length > 0) {
            self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
            self.sureBtn.enabled = YES;
        }
    }];
}
- (void)becomFirstResponder {
    self.endEditing = YES;
    [self.tagTF becomeFirstResponder];
}

- (void)enditing {
    [self endEditing:YES];
}
- (BOOL)isEndEdting {
    return self.endEditing;
}
- (void)setSelecte:(BOOL)selecte {
    _selecte = selecte;
    if (!selecte) {
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        self.layer.borderColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.tagLb.textColor = [UIColor colorWithHexString:@"333333"];
    }else {
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        self.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.tagLb.textColor = [UIColor colorWithHexString:@"F3344A"];
    }
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
}
- (void)selectClick {
    
    [self.viewModel.selectedEditingSuj sendNext:nil];
}
- (void)sureClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (self.tagTF.text.length <= 5) {
            self.selecte = YES;
            self.tagLb.hidden = NO;
            self.tagLb.text = self.tagTF.text;
            CGSize size = [self.tagLb sizeThatFits:CGSizeMake(100, 25)];
            self.tagLb.frame = CGRectMake(0, 0, size.width+15+15, 25);
            self.sureBtn.frame = CGRectMake(self.tagLb.right, 0, 40, 25);
            self.tagTF.hidden = YES;
//            [self.viewModel.sureTagSuj sendNext:self.tagLb];
            self.endEditing = NO;
            
        }else {
            
        }
    }else {
        self.tagTF.hidden = NO;
        self.tagLb.hidden = YES;
        self.tagTF.text = self.tagLb.text;
        [self becomFirstResponder];
         self.tagTF.frame = CGRectMake(15, 0, 185, 25);
        self.sureBtn.frame = CGRectMake(self.tagTF.right, 0, 40, 25);
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
//        [self.viewModel.sureTagSuj sendNext:self.tagTF];
    }
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.font = [UIFont systemFontOfSize:14];
        _tagLb.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick)];
        _tagLb.userInteractionEnabled = YES;
        [_tagLb addGestureRecognizer:tap];
    }
    return _tagLb;
}
- (UITextField *)tagTF {
    if (!_tagTF) {
        _tagTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 185, 25)];
//        NSMutableAttributedString *attrbute =
//        _tagTF.attributedPlaceholder
        _tagTF.placeholder = @"请输入标签名称，最多5个字";
        _tagTF.textColor = [UIColor blackColor];
        _tagTF.font = [UIFont systemFontOfSize:13];
        _tagTF.tintColor = [UIColor colorWithHexString:@"F3344A"];
        _tagTF.backgroundColor = [UIColor clearColor];
    }
    return _tagTF;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.tagTF.right, 0, 40, 25)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
         [_sureBtn setTitle:@"修改" forState:UIControlStateSelected];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        _sureBtn.enabled = NO;
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
