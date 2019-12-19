//
//  HFEditingAddressView.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFEditingAddressView.h"
#import "HFAddressViewModel.h"
#import "HFTagView.h"
#import "HFAddressListViewModel.h"
#import "HFCitySelectorView.h"
@interface HFEditingAddressView ()
@property (nonatomic,strong)UILabel *consigneeLb;
@property (nonatomic,strong)UITextField *consigneeTF;
@property (nonatomic,strong)CALayer *speartorLineOne;

@property (nonatomic,strong)UILabel *phoneLb;
@property (nonatomic,strong)UITextField *phoneTF;
@property (nonatomic,strong)CALayer *speartorLineTwo;

@property (nonatomic,strong)UILabel *areaLb;
@property (nonatomic,strong)UIButton *areaBtn;
@property (nonatomic,strong)UITextField *areaTF;
@property (nonatomic,strong)CALayer *speartorLineThree;

@property (nonatomic,strong)UILabel *areaNumLb;
@property (nonatomic,strong)UITextField *areaNumTF;
@property (nonatomic,strong)CALayer *speartorLineFour;

@property (nonatomic,strong)UILabel *detialAdrLb;
@property (nonatomic,strong)UITextView *detialAdrTF;
@property (nonatomic,strong)CALayer *speartorLineFive;


@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)CAGradientLayer *gl;
@property (nonatomic,strong)HFAddressListViewModel *viewModel;
@property (nonatomic,strong)HFCitySelectorView *citySelectoryView;
@end
@implementation HFEditingAddressView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}

- (void)hh_setupViews {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    [self addSubview:view];
    [self addSubview:self.consigneeLb];
    [self addSubview:self.consigneeTF];
    [self.layer addSublayer:self.speartorLineOne];
    [self addSubview:self.phoneLb];
    [self addSubview:self.phoneTF];
    [self.layer addSublayer:self.speartorLineTwo];
    [self addSubview:self.areaLb];
    [self addSubview:self.areaTF];
    [self addSubview:self.areaBtn];
    [self.layer addSublayer:self.speartorLineThree];
    [self addSubview:self.areaNumLb];
    [self addSubview:self.areaNumTF];
    [self.layer addSublayer:self.speartorLineFour];
    [self addSubview:self.detialAdrLb];
    [self addSubview:self.detialAdrTF];
    [self.layer addSublayer:self.speartorLineFive];

    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.saveBtn.frame;
    gl.startPoint = CGPointMake(0.02, 0.36);
    gl.endPoint = CGPointMake(0.99, 0.36);
    gl.cornerRadius = 20;
    gl.masksToBounds = YES;
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor, (__bridge id)[UIColor colorWithHexString:@"FF2E5D"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.gl = gl;
    [self.layer addSublayer:gl];
    [self addSubview:self.saveBtn];
}

- (void)hh_bindViewModel {
    self.consigneeLb.text = @"收货人: ";
    self.phoneLb.text =     @"手  机: ";
    self.areaLb.text =      @"地  区: ";
    self.areaNumLb.text =   @"邮  编: ";
    self.detialAdrLb.text = @"地  址: ";
    @weakify(self)

    
    RAC(self.saveBtn,backgroundColor) = [self.viewModel.validSigal map:^id _Nullable(id  _Nullable value) {
        if ([value boolValue]) {
            self.gl.hidden = NO;
            return [UIColor clearColor];
        }else {
            self.gl.hidden = YES;
            return [UIColor colorWithHexString:@"DDDDDD"];
        }
    }];
    RAC(self.saveBtn,enabled) = self.viewModel.validSigal;

    [self.viewModel.editingSetSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            HFAddressModel *model = (HFAddressModel*)x;
            self.consigneeTF.text = model.receiptName;
            self.phoneTF.text = model.receiptPhone;
            NSString *twon = @"";
            if ([model.townName isKindOfClass:[NSNull class]]) {
                twon = @"";
            }else {
                twon  = (model.townName.length ==0?@"":model.townName);
            }
            self.areaTF.text =[NSString stringWithFormat:@"%@ %@ %@ %@",model.cityName,model.regionName,model.blockName,twon];
            self.detialAdrTF.text = model.detailAddress;
            self.viewModel.model = model;
            self.viewModel.model.partAddress = self.areaTF.text;
            
        }
    }];
    RAC(self.viewModel, model.receiptName)= self.consigneeTF.rac_textSignal;
    RAC(self.viewModel, model.receiptPhone)= self.phoneTF.rac_textSignal;
    RAC(self.viewModel, model.partAddress)= self.areaTF.rac_textSignal;
    RAC(self.viewModel, model.detailAddress)= self.detialAdrTF.rac_textSignal;
    RAC(self.viewModel, model.zipCode)= self.areaNumTF.rac_textSignal;
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (![HFUntilTool isValidateByRegex:self.viewModel.model.receiptPhone]) {
            [MBProgressHUD showAutoMessage:@"请输入正确的手机号码"];
        }else {
            
            [self.viewModel.addressEditComand execute:nil];
        }
        

    }];

//    self.areaTF.text = @"河北省 秦皇岛市 山海关区 西关街道办事处";
//    self.viewModel.model.partAddress = self.areaTF.text;
//    self.viewModel.model.cityId = @"13400";
//    self.viewModel.model.regionId = @"25194";
//    self.viewModel.model.blockId = @"25594";
//    self.viewModel.model.townId = @"25609";
//    self.viewModel.model.ids = @"426698";
    
}
- (void)selectAddressClick:(UIButton*)btn {
//    [self.viewModel.selectAreaSubj sendNext:nil];
     [self.viewModel.regionCommand execute:nil];
    
     [self.citySelectoryView showCitySelector];


}
- (void)switchClick:(UISwitch*)swit {
    
}
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.height-40-20, ScreenW-20, 40)];
        _saveBtn.layer.cornerRadius = 20;
        _saveBtn.backgroundColor = [UIColor clearColor];
        [_saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
}
- (CALayer *)speartorLineFive {
    if (!_speartorLineFive) {
        _speartorLineFive = [CALayer layer];
        _speartorLineFive.frame = CGRectMake(0, self.detialAdrTF.bottom+0.5, ScreenW, 0.5);
        _speartorLineFive.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _speartorLineFive;
}
- (UITextView *)detialAdrTF {
    if (!_detialAdrTF) {
        _detialAdrTF = [[UITextView alloc] initWithFrame:CGRectMake(self.detialAdrLb.right-5, CGRectGetMaxY(self.speartorLineFour.frame)+5, ScreenW-56-15, 90-15)];
        _detialAdrTF.font = [UIFont systemFontOfSize:14];
       // _detialAdrTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
    }
    return _detialAdrTF;
}
- (UILabel *)detialAdrLb {
    if (!_detialAdrLb) {
        _detialAdrLb = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.speartorLineFour.frame)+15, 56, 15)];
        _detialAdrLb.textColor = [UIColor colorWithHexString:@"333333"];
        _detialAdrLb.font = [UIFont systemFontOfSize:14];
    }
    return _detialAdrLb;
    
}
- (CALayer *)speartorLineFour {
    if (!_speartorLineFour) {
        _speartorLineFour = [CALayer layer];
        _speartorLineFour.frame = CGRectMake(0, self.areaNumTF.bottom+0.5, ScreenW, 0.5);
        _speartorLineFour.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        
    }
    return _speartorLineFour;
}
- (UITextField *)areaNumTF {
    if (!_areaNumTF) {
        _areaNumTF = [[UITextField alloc] initWithFrame:CGRectMake(self.areaNumLb.right, CGRectGetMaxY(self.speartorLineThree.frame), ScreenW-56-15, 44)];
        _areaNumTF.font = [UIFont systemFontOfSize:14];
      
        
    }
    return _areaNumTF;
}
- (UILabel *)areaNumLb {
    if (!_areaNumLb) {
        _areaNumLb = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.speartorLineThree.frame)+15, 56, 15)];
        _areaNumLb.textColor = [UIColor colorWithHexString:@"333333"];
        _areaNumLb.font = [UIFont systemFontOfSize:14];
    }
    return _areaNumLb;
}
- (CALayer *)speartorLineThree {
    if (!_speartorLineThree) {
        _speartorLineThree = [CALayer layer];
        _speartorLineThree.frame = CGRectMake(0, self.areaBtn.bottom+0.5, ScreenW, 0.5);
        _speartorLineThree.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        
    }
    return _speartorLineThree;
}
- (UIButton *)areaBtn {
    if (!_areaBtn) {
        _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.speartorLineTwo.frame), ScreenW, 45)];
        _areaBtn.backgroundColor = [UIColor clearColor];
        [_areaBtn setImage:[UIImage imageNamed:@"SpTypes_group"] forState:UIControlStateNormal];
        [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_areaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, ScreenW-30, 0, 0)];
        [_areaBtn addTarget:self action:@selector(selectAddressClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaBtn;
}
- (UILabel *)areaLb {
    if (!_areaLb) {
        _areaLb = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.speartorLineTwo.frame)+15, 56, 15)];
        _areaLb.textColor = [UIColor colorWithHexString:@"333333"];
        _areaLb.font = [UIFont systemFontOfSize:14];
        
    }
    return _areaLb;
}
- (UITextField *)areaTF {
    if (!_areaTF) {
        _areaTF = [[UITextField alloc] initWithFrame:CGRectMake(self.areaLb.right, CGRectGetMaxY(self.speartorLineTwo.frame)+15, ScreenW-self.areaLb.right, 15)];
        _areaTF.textColor = [UIColor colorWithHexString:@"333333"];
        _areaTF.font = [UIFont systemFontOfSize:14];
    }
    return _areaTF;
}
- (CALayer *)speartorLineTwo {
    if (!_speartorLineTwo) {
        _speartorLineTwo = [CALayer layer];
        _speartorLineTwo.frame = CGRectMake(0, self.phoneTF.bottom+0.5,  ScreenW, 0.5);
        _speartorLineTwo.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;

    }
    return _speartorLineTwo;
}
- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneLb.right, CGRectGetMaxY(self.speartorLineOne.frame), ScreenW-self.consigneeLb.right, 44)];
        _phoneTF.font = [UIFont systemFontOfSize:14];
    }
    return _phoneTF;
}
- (UILabel *)phoneLb {
    if (!_phoneLb) {
        _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.speartorLineOne.frame)+15, 56, 15)];
        _phoneLb.textColor = [UIColor colorWithHexString:@"333333"];
        _phoneLb.font = [UIFont systemFontOfSize:14];
    }
    return _phoneLb;
}

- (CALayer *)speartorLineOne {
    if (!_speartorLineOne) {
        _speartorLineOne = [CALayer layer];
        _speartorLineOne.frame = CGRectMake(0, self.consigneeTF.bottom, ScreenW, 0.5);
        _speartorLineOne.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _speartorLineOne;
}
- (UITextField *)consigneeTF {
    if (!_consigneeTF) {
        _consigneeTF = [[UITextField alloc] initWithFrame:CGRectMake(self.consigneeLb.right, 1, ScreenW- self.consigneeLb.right, 44)];
        _consigneeTF.font = [UIFont systemFontOfSize:14];
    }
    return _consigneeTF;
}
- (UILabel *)consigneeLb {
    if (!_consigneeLb) {
        _consigneeLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 56, 15)];
        _consigneeLb.textColor = [UIColor colorWithHexString:@"333333"];
        _consigneeLb.font = [UIFont systemFontOfSize:14];
    }
    return _consigneeLb;
}
- (HFCitySelectorView *)citySelectoryView {
    if (!_citySelectoryView) {
        _citySelectoryView = [[HFCitySelectorView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) WithViewModel:self.viewModel];
        _citySelectoryView.hidden = YES;
    }
    return _citySelectoryView;
}
@end
