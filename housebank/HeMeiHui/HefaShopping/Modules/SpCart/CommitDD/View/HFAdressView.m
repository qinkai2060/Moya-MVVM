//
//  HFAdressView.m
//  housebank
//
//  Created by usermac on 2018/11/15.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAdressView.h"
#import "HFAddressModel.h"
@interface HFAdressView ()
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *phoneNmLb;
//@property (nonatomic,strong) UILabel *defaultAdrLb;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) UILabel *detailAdressLb;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UIImageView *caiseImageV;

@property (nonatomic,strong) UIImageView *emptyImagev;
@property (nonatomic,strong) UILabel *emptyLb;
//@property (nonatomic,assign) NSInteger isEmpty;
@property (nonatomic,strong) HFPayMentViewModel *viewModel;
@property (nonatomic,strong) HFAddressModel *addressModel;
@property (nonatomic,strong) UIButton *clickEvent;
@end
@implementation HFAdressView
- (instancetype)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLb];
    [self addSubview:self.phoneNmLb];
  //  [self addSubview:self.defaultAdrLb];
//    [self addSubview:self.tagLb];
    [self addSubview:self.imageV];
    [self addSubview:self.detailAdressLb];
    [self addSubview:self.caiseImageV];
    
    [self addSubview:self.emptyImagev];
    [self addSubview:self.emptyLb];
    [self addSubview:self.clickEvent];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.addressSubj subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFAddressModel *model = (HFAddressModel*)x;
        NSLog(@"🌈%@ --- %d",model.completeAddress,model.defalutAddress);
        self.caiseImageV.image = [UIImage imageNamed:@"caiseLine"];
        self.imageV.image = [UIImage imageNamed:@"advance"];
        self.emptyImagev.image = [UIImage imageNamed:@"round_add_light"];
        self.emptyLb.text = @"添加收货地址";
//        self.defaultAdrLb.text = @"默认";
//        self.defaultAdrLb.hidden = YES;
        if (model!=nil) {
            self.addressModel = model;
        
                self.nameLb.text = model.receiptName;
                CGSize sizeName = [self.nameLb sizeThatFits:CGSizeMake(48, 20)];
                self.nameLb.frame = CGRectMake(15, 15, sizeName.width, 20);
            if (model.receiptPhone.length>=11) {
                self.phoneNmLb.text = model.receiptPhone;// [model.receiptPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
                self.phoneNmLb.frame = CGRectMake(self.nameLb.right+10, 15, 120, 20);
                self.tagLb.text = @"公司";
                CGSize sizeTag = [self.tagLb sizeThatFits:CGSizeMake(50, 15)];
            if (model.receiptPhone.length == 0) {
                   // self.defaultAdrLb.frame = CGRectMake(self.nameLb.right+5, 18, 30, 15);
            }else {
                  //  self.defaultAdrLb.frame = CGRectMake(self.phoneNmLb.right+5, 18, 30, 15);
            }
            
               // self.tagLb.frame = CGRectMake(self.defaultAdrLb.right+5, 18, sizeTag.width+10, 15);
                self.detailAdressLb.text = model.completeAddress;
                CGSize sizedetailAdress = [self.detailAdressLb sizeThatFits:CGSizeMake(ScreenW - 15-15, 40)];
                self.detailAdressLb.frame = CGRectMake(15, self.phoneNmLb.bottom+10, ScreenW - 15-15-15, sizedetailAdress.height);
                self.caiseImageV.frame = CGRectMake(3, self.detailAdressLb.bottom+15, ScreenW-6, 3);
                [self isEmpty:NO];
          
         
        }else {
            self.addressModel = nil;
            self.emptyImagev.frame = CGRectMake(15, 18, 15, 15);
            self.emptyLb.frame = CGRectMake(self.emptyImagev.right+15, 15, 120, 20);
            self.caiseImageV.frame = CGRectMake(3, self.emptyImagev.bottom+15, ScreenW-6, 3);
            [self isEmpty:YES];
        }
        self.clickEvent.frame = CGRectMake(0, 0, ScreenW, self.caiseImageV.top);
        self.frame = CGRectMake(0, 0, ScreenW, self.caiseImageV.bottom);
  
    }];
      [self.viewModel.resetAddressSubjc subscribeNext:^(id  _Nullable x) {
          
          HFAddressModel *model = (HFAddressModel*)x;
          self.addressModel = model;
          
          self.nameLb.text = model.receiptName;
          CGSize sizeName = [self.nameLb sizeThatFits:CGSizeMake(48, 20)];
          self.nameLb.frame = CGRectMake(15, 15, sizeName.width, 20);
          if (model.receiptPhone.length>=11) {
              self.phoneNmLb.text = model.receiptPhone;// [model.receiptPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
          }
          self.phoneNmLb.frame = CGRectMake(self.nameLb.right+10, 15, 120, 20);
          self.tagLb.text = @"公司";
          CGSize sizeTag = [self.tagLb sizeThatFits:CGSizeMake(50, 15)];
          if (model.receiptPhone.length == 0) {
              // self.defaultAdrLb.frame = CGRectMake(self.nameLb.right+5, 18, 30, 15);
          }else {
              //  self.defaultAdrLb.frame = CGRectMake(self.phoneNmLb.right+5, 18, 30, 15);
          }
          
          // self.tagLb.frame = CGRectMake(self.defaultAdrLb.right+5, 18, sizeTag.width+10, 15);
          self.detailAdressLb.text = model.completeAddress;
          CGSize sizedetailAdress = [self.detailAdressLb sizeThatFits:CGSizeMake(ScreenW - 15-15-15-15, 40)];
          self.detailAdressLb.frame = CGRectMake(15, self.phoneNmLb.bottom+10, ScreenW - 15-15-15, sizedetailAdress.height);
          self.caiseImageV.frame = CGRectMake(3, self.detailAdressLb.bottom+15, ScreenW-6, 3);
          [self isEmpty:NO];
          self.clickEvent.frame = CGRectMake(0, 0, ScreenW, self.caiseImageV.top);
          self.frame = CGRectMake(0, 0, ScreenW, self.caiseImageV.bottom);
      }];
  
   
}
- (void)isEmpty:(BOOL)isEmpty {
    self.nameLb.hidden = isEmpty;
    self.phoneNmLb.hidden = isEmpty;
    self.tagLb.hidden = isEmpty;
  //  self.defaultAdrLb.hidden = isEmpty;
    self.detailAdressLb.hidden = isEmpty;
    if(isEmpty == NO) {
        self.emptyImagev.hidden = YES;
        self.emptyLb.hidden = YES;
    }else {
        self.emptyImagev.hidden = NO;
        self.emptyLb.hidden = NO;
    }

  
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(ScreenW-15-15, (self.height-15)*0.5, 15, 15);
  
}
- (void)enterClick:(UIButton*)btn {
 
        [self.viewModel.enterAddressOrEditingSubj sendNext:self.addressModel];
}
- (UIButton *)clickEvent {
    if (!_clickEvent) {
        _clickEvent = [[UIButton alloc] init];
        _clickEvent.backgroundColor = [UIColor clearColor];
        [_clickEvent addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickEvent;
}
- (UIImageView *)emptyImagev {
    if (!_emptyImagev) {
        _emptyImagev = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
       
    }
    return _emptyImagev;
}
- (UILabel *)emptyLb {
    if (!_emptyLb) {
        _emptyLb = [[UILabel alloc] init];
        _emptyLb.font = [UIFont systemFontOfSize:16];
        _emptyLb.textColor = [UIColor blackColor];
     
    }
    return _emptyLb;
}
- (UIImageView *)caiseImageV {
    if (!_caiseImageV) {
        _caiseImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW -15-15, 0, 15, 15)];
       
      
    }
    return _caiseImageV;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW -15-15, 0, 15, 15)];
      
    }
    return _imageV;
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.font = [UIFont systemFontOfSize:8];
        _tagLb.layer.cornerRadius = 7.5;
        _tagLb.layer.masksToBounds = YES;
        _tagLb.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
        _tagLb.textColor = [UIColor whiteColor];
        _tagLb.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLb;
}
//- (UILabel *)defaultAdrLb {
//    if(!_defaultAdrLb){
//        _defaultAdrLb = [[UILabel alloc] init];
//
//        _defaultAdrLb.font = [UIFont systemFontOfSize:8];
//        _defaultAdrLb.layer.cornerRadius = 7.5;
//        _defaultAdrLb.layer.masksToBounds = YES;
//        _defaultAdrLb.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
//        _defaultAdrLb.textColor = [UIColor whiteColor];
//        _defaultAdrLb.textAlignment = NSTextAlignmentCenter;
//    }
//    return _defaultAdrLb;
//}
- (UILabel *)detailAdressLb {
    if (!_detailAdressLb) {
        _detailAdressLb = [[UILabel alloc] init];
        _detailAdressLb.textColor = [UIColor colorWithHexString:@"666666"];
        _detailAdressLb.font = [UIFont systemFontOfSize:12];
        _detailAdressLb.numberOfLines = 0;
//        _detailAdressLb.backgroundColor= [UIColor redColor];
    }
    return _detailAdressLb;
}
- (UILabel *)phoneNmLb {
    if (!_phoneNmLb) {
        _phoneNmLb = [[UILabel alloc] init];
        _phoneNmLb.textColor = [UIColor blackColor];
        _phoneNmLb.font = [UIFont systemFontOfSize:16];
        
    }
    return _phoneNmLb;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        _nameLb.textColor = [UIColor colorWithHexString:@"333333"];
        _nameLb.font = [UIFont boldSystemFontOfSize:16];
        _nameLb.lineBreakMode =  NSLineBreakByTruncatingTail;
    }
    return _nameLb;
}
@end
