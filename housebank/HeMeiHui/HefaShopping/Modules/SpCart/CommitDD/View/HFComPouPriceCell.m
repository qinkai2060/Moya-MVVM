//
//  HFComPouPriceCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFComPouPriceCell.h"
@interface HFComPouPriceCell()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *titlelb;
@property (nonatomic,strong) UILabel *pricelb;
@property (nonatomic,strong) UITextField *textfield;
@property (nonatomic,strong) UIButton *checkBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *signpricelb;
@end
@implementation HFComPouPriceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titlelb];
        [self.contentView addSubview:self.checkBtn];
        [self.contentView addSubview:self.pricelb];
        [self.contentView addSubview:self.textfield];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.titlelb];
    }
    return self;
}
- (void)dataSomthing {
    
    self.titlelb.text = self.compouModel.name;
    self.titlelb.frame = CGRectMake(15, 15, 65, 15);
    self.checkBtn.selected = YES;
    self.checkBtn.frame = CGRectMake(ScreenW -15-20, 13, 20, 20);
    if (self.compouModel.value != 0) {
        self.pricelb.text = [NSString stringWithFormat:@"-¥%ld",(long)self.compouModel.value];
        
       self.pricelb.hidden = NO;
       self.pricelb.textColor = [UIColor colorWithHexString:@"333333"];
       self.checkBtn.enabled = YES;
 
    }else {
        if ([self.compouModel.name isEqualToString:@"抵扣券"]) {
            self.pricelb.hidden = NO;
            self.pricelb.text = @"不可使用";
            self.checkBtn.enabled = NO;
            self.pricelb.textColor = [UIColor colorWithHexString:@"999999"];
        }else if ([self.compouModel.name isEqualToString:@"注册券"]){
            self.pricelb.hidden = NO;
            self.pricelb.text = @"不可使用";
            self.checkBtn.enabled = NO;
            self.pricelb.textColor = [UIColor colorWithHexString:@"999999"];
        }else {
             self.pricelb.textColor = [UIColor colorWithHexString:@"999999"];
              self.checkBtn.enabled = YES;
             self.pricelb.hidden = YES;
        }
      
  
    }
    self.checkBtn.selected = self.compouModel.select;
    CGSize princeSize = [self.pricelb sizeThatFits:CGSizeMake(100, 15)];
    self.pricelb.frame = CGRectMake(self.checkBtn.left-princeSize.width - 10, 15,princeSize.width , princeSize.height);
    self.lineView.frame = CGRectMake(15, self.titlelb.bottom+15, ScreenW-30, 1);
}
- (void)selectClick {
    if ([self.delegate respondsToSelector:@selector(didSelectAndUnselectFunction:withModel:)]) {
        [self.delegate didSelectAndUnselectFunction:self withModel:self.compouModel];
    }
}
- (UILabel *)titlelb {
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titlelb;
}
- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] init];
        [_checkBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [_checkBtn setImage:[UIImage imageNamed:@"car_disable_icon"] forState:UIControlStateDisabled];
        [_checkBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}
- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] init];
        _textfield.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _textfield.layer.borderWidth = 0.5;
        _textfield.textColor = [UIColor colorWithHexString:@"999999"];
        _textfield.font = [UIFont systemFontOfSize:14];
        _textfield.text = @"1";
        _textfield.textAlignment = NSTextAlignmentCenter;
        _textfield.keyboardType =  UIKeyboardTypeNumberPad;
        _textfield.delegate = self;
        
    }
    return _textfield;
}
- (UILabel *)pricelb {
    if (!_pricelb) {
        _pricelb = [[UILabel alloc] init];
        _pricelb.font = [UIFont boldSystemFontOfSize:14];
    }
    return _pricelb;
}
- (UILabel *)signpricelb {
    if (!_signpricelb) {
        _signpricelb = [[UILabel alloc] init];
        _signpricelb.font = [UIFont boldSystemFontOfSize:14];
    }
    return _signpricelb;
}
- (UIView *)lineView  {
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _lineView;
}
@end
