//
//  HFPayMentCell.m
//  housebank
//
//  Created by usermac on 2018/11/14.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPayMentCell.h"
#import "HFPayMentShoppsCell.h"
#import "HFTextCovertImage.h"
@interface HFPayMentCell ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) UILabel *disCountLb;
//@property (nonatomic,strong) UIImageView *alertCouponsImgV;
//@property (nonatomic,strong) UILabel *disTypeValueLb;
//@property (nonatomic,strong) UIButton *btn;
//@property (nonatomic,strong) CALayer *lineLayerOne;
@property (nonatomic,strong) CAGradientLayer *gratlayer;

@property (nonatomic,strong) UILabel *loveRedPaketLb;
@property (nonatomic,strong) UILabel *loveRedPaketCountLb;
@property (nonatomic,strong) UILabel *loveRedPakeValueLb;
@property (nonatomic,strong) UIButton *loveRedPakeValuebtn;
@property (nonatomic,strong) UIButton *loveRedBtn;
@property (nonatomic,strong) CALayer *lineLayerTwo;

@property (nonatomic,strong) UILabel *dispatchingLb;
@property (nonatomic,strong) UILabel *dispatchingValueLb;
@property (nonatomic,strong) CALayer *lineLayerThree;

@property (nonatomic,strong) UILabel *leveaWordLb;
@property (nonatomic,strong) UITextField *leveaWordTF;
@property (nonatomic,strong) CALayer *lineLayerFour;

@property (nonatomic,strong) UILabel *totalPricesPrefixLb;
@property (nonatomic,strong) UILabel *totalPricesLb;
@end
@implementation HFPayMentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.tableView];
        
        //[self.contentView addSubview:self.disCountLb];
        //        [self.contentView addSubview:self.alertCouponsImgV];
        //         [self.contentView.layer addSublayer:self.gratlayer];
        //        [self.contentView addSubview:self.disTypeValueLb];
        //        [self.contentView.layer addSublayer:self.lineLayerOne];
        
        [self.contentView addSubview:self.loveRedPaketLb];
        [self.contentView addSubview:self.loveRedPaketCountLb];
        [self.contentView addSubview:self.loveRedPakeValuebtn];
        [self.contentView.layer addSublayer:self.gratlayer];
        [self.contentView addSubview:self.loveRedPakeValueLb];
        [self.contentView.layer addSublayer:self.lineLayerTwo];
        [self.contentView addSubview:self.loveRedBtn];
        
        [self.contentView addSubview:self.dispatchingLb];
        [self.contentView addSubview:self.dispatchingValueLb];
        [self.contentView.layer addSublayer:self.lineLayerThree];
        
        [self.contentView addSubview:self.leveaWordLb];
        [self.contentView addSubview:self.leveaWordTF];
        [self.contentView.layer addSublayer:self.lineLayerFour];
        
        [self.contentView addSubview:self.totalPricesLb];
        [self.contentView addSubview:self.totalPricesPrefixLb];
        @weakify(self)
        [[self.leveaWordTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            NSString *str = x;
            self.leveaWordTF.text = [str length] > 90 ?[str substringToIndex:90]:str;
            self.model.textContent = self.leveaWordTF.text;
        }];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.commodityList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFPayMentShoppsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.productModel = self.model.commodityList[indexPath.row];
    [cell doDataSomthing];
    cell.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(textEndWithTextField:cell:)]) {
        [self.delegate textEndWithTextField:[textField.text length] > 5 ?[textField.text substringToIndex:5]:textField.text cell:self];
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)doMessageSomthing {
    self.tableView.frame = CGRectMake(0, 0, ScreenW, 100*self.model.commodityList.count);
    
    self.loveRedPaketLb.text = @"优惠券";

    self.loveRedPaketCountLb.text = [NSString stringWithFormat:@"已选%lu张",(unsigned long)self.model.selectCoupouList.count];
    self.loveRedPaketCountLb.hidden = YES;
    self.dispatchingLb.text = @"配送方式";
    
    if (self.model.shopAllPostages <= 0) {
        self.dispatchingValueLb.text = @"快递 免邮";
    }else {
        self.dispatchingValueLb.text = [NSString stringWithFormat:@"快递 ¥%.2f",self.model.shopAllPostages];
        
    }
   
    
    if (self.model.couponPrice <= 0) {
        if(self.model.isVIPPackage){// 是否是VIP礼包
            self.loveRedPakeValueLb.text  = @"无可用";
            self.gratlayer.hidden = YES;
             self.loveRedPakeValuebtn.frame = CGRectZero;
            self.loveRedPakeValueLb.textColor =  [UIColor colorWithHexString:@"333333"];;
            self.loveRedPaketLb.frame = CGRectZero;
            self.loveRedPaketCountLb.frame = CGRectZero;
            self.loveRedPakeValueLb.frame = CGRectZero;
            self.gratlayer.frame = CGRectZero;
            self.lineLayerTwo.frame = CGRectZero;
            self.loveRedBtn.frame = CGRectZero;
            self.dispatchingLb.frame = CGRectMake(15, self.tableView.bottom+15, 65, 15);
//            CGSize sizeDisptching = [self.dispatchingValueLb sizeThatFits:CGSizeMake(ScreenW - 30 - self.dispatchingLb.width, 15)];
            self.dispatchingValueLb.frame = CGRectMake(self.dispatchingLb.right,   self.tableView.bottom+15, ScreenW - 30 - self.dispatchingLb.width, 15);
            self.lineLayerThree.frame = CGRectMake(15, CGRectGetMaxY(self.dispatchingLb.frame)+15, ScreenW-30, 0.5);
        }else{
            
            if (self.model.selectCoupouList.count == 0 &&self.model.conpoumodel.available.count > 0) {
                self.loveRedPakeValueLb.text  = [NSString stringWithFormat:@"%ld张可用",(unsigned long)self.model.conpoumodel.available.count];
                self.gratlayer.hidden = NO;
                self.loveRedPakeValueLb.textColor = [UIColor whiteColor];
            }else {
                self.gratlayer.hidden = YES;
                self.loveRedPakeValueLb.text  = @"无可用";
                self.loveRedPakeValueLb.textColor =  [UIColor colorWithHexString:@"333333"];;
            }
             CGSize sizeRed = [self.loveRedPakeValueLb sizeThatFits:CGSizeMake(self.loveRedPakeValuebtn.left - 65 - 15, 15)];
            self.loveRedPakeValuebtn.frame = CGRectMake(ScreenW-15-20,  self.tableView.bottom+13, 20, 20);
            self.loveRedPaketLb.frame = CGRectMake(15, self.tableView.bottom+15, 65, 15);
            self.loveRedPaketCountLb.frame = CGRectMake(self.loveRedPaketLb.right+5, self.tableView.bottom+15, 50, 18);
            self.loveRedPakeValueLb.frame = CGRectMake(self.loveRedPakeValuebtn.left-sizeRed.width-10,  self.tableView.bottom+15, sizeRed.width,15);
            self.gratlayer.frame = CGRectMake(self.loveRedPakeValuebtn.left-sizeRed.width-10-10, self.tableView.bottom+12.5, sizeRed.width+20, 20);
            self.lineLayerTwo.frame = CGRectMake(15, self.loveRedPaketLb.bottom+15, ScreenW-30, 0.5);
            self.loveRedBtn.frame = CGRectMake(0, self.tableView.bottom, ScreenW, 45);
            self.dispatchingLb.frame = CGRectMake(15, self.lineLayerTwo.bottom+15, 65, 15);
//            CGSize sizeDisptching = [self.dispatchingValueLb sizeThatFits:CGSizeMake(ScreenW - 30 - self.dispatchingLb.width, 15)];
            self.dispatchingValueLb.frame = CGRectMake(self.dispatchingLb.right, self.lineLayerTwo.bottom+15, ScreenW - 30 - self.dispatchingLb.width, 15);
            self.lineLayerThree.frame = CGRectMake(15, CGRectGetMaxY(self.dispatchingLb.frame)+15, ScreenW-30, 0.5);
        }
        
 
    }else {
    
        self.gratlayer.hidden = YES;
        self.loveRedPakeValueLb.text = [NSString stringWithFormat:@"-¥ %.f",self.model.couponPrice];
        self.loveRedPakeValueLb.textColor =  [UIColor colorWithHexString:@"F3344A"];;
        self.loveRedPakeValuebtn.frame = CGRectMake(ScreenW-15-20,  self.tableView.bottom+13, 20, 20);
        self.loveRedPaketLb.frame = CGRectMake(15, self.tableView.bottom+15, 65, 15);
        self.loveRedPaketCountLb.frame = CGRectMake(self.loveRedPaketLb.right+5, self.tableView.bottom+15, 50, 18);
         CGSize sizeRed = [self.loveRedPakeValueLb sizeThatFits:CGSizeMake(self.loveRedPakeValuebtn.left - 65 - 15, 15)];
        self.loveRedPakeValueLb.frame = CGRectMake(self.loveRedPakeValuebtn.left-sizeRed.width-10,  self.tableView.bottom+15, sizeRed.width,15);
        self.gratlayer.frame = CGRectMake(self.loveRedPakeValuebtn.left-sizeRed.width-10-10, self.tableView.bottom+12.5, sizeRed.width+20, 20);
        self.lineLayerTwo.frame = CGRectMake(15, self.loveRedPaketLb.bottom+15, ScreenW-30, 0.5);
        self.loveRedBtn.frame = CGRectMake(0, self.tableView.bottom, ScreenW, 45);
        self.dispatchingLb.frame = CGRectMake(15, self.lineLayerTwo.bottom+15, 65, 15);
//        CGSize sizeDisptching = [self.dispatchingValueLb sizeThatFits:CGSizeMake(ScreenW - 30 - self.dispatchingLb.width, 15)];
        self.dispatchingValueLb.frame = CGRectMake(self.dispatchingLb.right, self.lineLayerTwo.bottom+15, ScreenW - 30 - self.dispatchingLb.width, 15);
        self.lineLayerThree.frame = CGRectMake(15, CGRectGetMaxY(self.dispatchingLb.frame)+15, ScreenW-30, 0.5);
    }
    
   



    
    self.leveaWordLb.text = @"买家留言";
    self.leveaWordTF.placeholder = @"选填:填写内容已和卖家协商确定";
    self.leveaWordTF.text = self.model.textContent;
    self.leveaWordLb.frame = CGRectMake(15, CGRectGetMaxY(self.lineLayerThree.frame)+20, 65, 15);
    self.leveaWordTF.frame = CGRectMake(self.leveaWordLb.right+5, CGRectGetMaxY(self.lineLayerThree.frame)+6, ScreenW-15-65-30, 45);
    self.lineLayerFour.frame = CGRectMake(15, CGRectGetMaxY(self.leveaWordTF.frame), ScreenW-30, 0.5);
    
    self.totalPricesLb.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.model.shopsProductPrice] twoText:@""];
    CGSize sizeTotal = [self.totalPricesLb sizeThatFits:CGSizeMake(100, 15)];
    self.totalPricesLb.frame = CGRectMake(ScreenW-sizeTotal.width-15, CGRectGetMaxY(self.lineLayerFour.frame)+15, sizeTotal.width, 15);
    self.totalPricesPrefixLb.text = [NSString stringWithFormat:@"共%ld件商品  合计: ",self.model.count];
    CGSize sizePrefix = [self.totalPricesPrefixLb sizeThatFits:CGSizeMake(100, 15)];
    self.totalPricesPrefixLb.frame = CGRectMake(self.totalPricesLb.left-sizePrefix.width, CGRectGetMaxY(self.lineLayerFour.frame)+15, sizePrefix.width, 15);
    [self.tableView reloadData];
    @weakify(self)
    [[self.loveRedBtn rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(paymentCell:model:)]) {
            if (self.model.conpoumodel.available.count >0) {
                [self.delegate paymentCell:self model:self.model];
            }

        }
        
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (UILabel *)totalPricesPrefixLb {
    if (!_totalPricesPrefixLb) {
        _totalPricesPrefixLb = [[UILabel alloc] init];
        _totalPricesPrefixLb.textColor = [UIColor colorWithHexString:@"333333"];
        _totalPricesPrefixLb.font = [UIFont systemFontOfSize:12];
    }
    return _totalPricesPrefixLb;
}
- (UILabel *)totalPricesLb {
    if (!_totalPricesLb) {
        _totalPricesLb = [[UILabel alloc] init];
        _totalPricesLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _totalPricesLb.font = [UIFont systemFontOfSize:15];
    }
    return _totalPricesLb;
}
- (CALayer *)lineLayerFour {
    if (!_lineLayerFour) {
        _lineLayerFour = [CALayer layer];
        _lineLayerFour.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _lineLayerFour;
}
- (UITextField *)leveaWordTF {
    if (!_leveaWordTF) {
        _leveaWordTF = [[UITextField alloc] init];
        _leveaWordTF.textColor = [UIColor colorWithHexString:@"333333"];
        _leveaWordTF.font = [UIFont systemFontOfSize:15];
        _leveaWordTF.delegate = self;
        //        _leveaWordL
    }
    return _leveaWordTF;
}
- (UILabel *)leveaWordLb {
    if (!_leveaWordLb) {
        _leveaWordLb = [[UILabel alloc] init];
        _leveaWordLb.textColor = [UIColor colorWithHexString:@"333333"];
        _leveaWordLb.font = [UIFont systemFontOfSize:14];
    }
    return _leveaWordLb;
}
- (CALayer *)lineLayerThree {
    if (!_lineLayerThree) {
        _lineLayerThree = [CALayer layer];
        _lineLayerThree.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _lineLayerThree;
}
- (UILabel *)dispatchingValueLb {
    if (!_dispatchingValueLb) {
        _dispatchingValueLb = [[UILabel alloc] init];
        _dispatchingValueLb.textColor = [UIColor colorWithHexString:@"333333"];
        _dispatchingValueLb.font = [UIFont systemFontOfSize:14];
        _dispatchingValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _dispatchingValueLb;
}
- (UILabel *)dispatchingLb {
    if (!_dispatchingLb) {
        _dispatchingLb = [[UILabel alloc] init];
        _dispatchingLb.textColor = [UIColor colorWithHexString:@"333333"];
        _dispatchingLb.font = [UIFont systemFontOfSize:14];
    }
    return _dispatchingLb;
}
- (CALayer *)lineLayerTwo {
    if (!_lineLayerTwo) {
        _lineLayerTwo = [CALayer layer];
        _lineLayerTwo.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _lineLayerTwo;
}
- (UILabel *)loveRedPakeValueLb {
    if (!_loveRedPakeValueLb) {
        _loveRedPakeValueLb = [[UILabel alloc] init];
        _loveRedPakeValueLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _loveRedPakeValueLb.font = [UIFont systemFontOfSize:15];
    }
    return _loveRedPakeValueLb;
    
}
- (UIButton *)loveRedPakeValuebtn {
    if (!_loveRedPakeValuebtn) {
        _loveRedPakeValuebtn = [[UIButton alloc] init];
        [_loveRedPakeValuebtn setImage:[UIImage imageNamed:@"order_icon-arrow"] forState:UIControlStateNormal];
        //        [_loveRedPakeValuebtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    }
    return _loveRedPakeValuebtn;
}
- (UILabel *)loveRedPaketLb {
    if (!_loveRedPaketLb) {
        _loveRedPaketLb = [[UILabel alloc] init];
        _loveRedPaketLb.textColor = [UIColor colorWithHexString:@"333333"];
        _loveRedPaketLb.font = [UIFont systemFontOfSize:14];
    }
    return _loveRedPaketLb;
}
- (UILabel *)loveRedPaketCountLb {
    if (!_loveRedPaketCountLb) {
        _loveRedPaketCountLb = [[UILabel alloc] init];
        _loveRedPaketCountLb.textColor = [UIColor colorWithHexString:@"FF0000"];
        _loveRedPaketCountLb.font = [UIFont systemFontOfSize:10];
        _loveRedPaketCountLb.textAlignment = NSTextAlignmentCenter;
        _loveRedPaketCountLb.layer.borderWidth = 1;
        _loveRedPaketCountLb.layer.borderColor = [UIColor colorWithHexString:@"FF0000"].CGColor;
        _loveRedPaketCountLb.layer.cornerRadius = 2;
        _loveRedPaketCountLb.layer.masksToBounds = YES;
    }
    return _loveRedPaketCountLb;
}
- (UIButton *)loveRedBtn {
    if (!_loveRedBtn) {
        _loveRedBtn = [[UIButton alloc] init];
    }
    return _loveRedBtn;
    
}
//- (CALayer *)lineLayerOne {
//    if (!_lineLayerOne) {
//        _lineLayerOne = [CALayer layer];
//        _lineLayerOne.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
//    }
//    return _lineLayerOne;
//}
//- (UILabel *)disTypeValueLb {
//    if (!_disTypeValueLb) {
//        _disTypeValueLb = [[UILabel alloc] init];
//        _disTypeValueLb.textColor = [UIColor colorWithHexString:@"F3344A"];
//        _disTypeValueLb.font = [UIFont systemFontOfSize:15];
//    }
//    return _disTypeValueLb;
//}
//- (UIImageView *)alertCouponsImgV {
//    if (!_alertCouponsImgV) {
//        _alertCouponsImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon-arrow"]];
//    }
//    return _alertCouponsImgV;
//}
- (CAGradientLayer *)gratlayer {
    if (!_gratlayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        gradientLayer.hidden = YES;
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
        gradientLayer.cornerRadius = 2;
        gradientLayer.masksToBounds = YES;
        _gratlayer = gradientLayer;
//        [self.layer addSublayer:gradientLayer];
    }
    return _gratlayer;
}

//- (UILabel *)disCountLb {
//    if (!_disCountLb) {
//        _disCountLb = [[UILabel alloc] init];
//        _disCountLb.textColor = [UIColor colorWithHexString:@"333333"];
//        _disCountLb.font = [UIFont systemFontOfSize:14];
//    }
//    return _disCountLb;
//}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFPayMentShoppsCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
