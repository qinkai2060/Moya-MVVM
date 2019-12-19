//
//  HFYHQView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYHQView.h"
#import "HFYHQCell.h"
#import "HFPaymentBaseModel.h"
#import "HFTextCovertImage.h"
@interface HFYHQView()<UITableViewDelegate,UITableViewDataSource,HFYHQCellDelegate>
@property(nonatomic,strong) HFPayMentViewModel *viewModel;
@property(nonatomic,strong) HFOrderShopModel *model;
@property(nonatomic,strong) NSMutableArray *selectCoupouList;
@property(nonatomic,strong)UIView *cornalView;

@property(nonatomic,strong)UIScrollView *scrollerView;
@property(nonatomic,strong)UITableView *enableTb;
@property(nonatomic,strong)UITableView *disableTb;

//@property(nonatomic,strong)UIScrollView *scrollerView;
@property(nonatomic,strong)UIButton *bgBtn;
@property(nonatomic,strong)UIButton *enabledBtn;
@property(nonatomic,strong)UIButton *disabledBtn; //评价
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIImageView *indecatoImgV;
@property(nonatomic,strong)UIView *lineView;


//@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *sureBtn;

@property(nonatomic,strong)UIButton *tuijianBtn;
@property(nonatomic,strong)UILabel *showYHQValueLb;

@property (nonatomic,strong) CAGradientLayer *gratlayer;

@end
@implementation HFYHQView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFPayMentViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        //
        // 10 10 10 10 10 10 10
    }
    return self;
}
- (void)showCar {
    self.hidden = NO;
    self.bgBtn.alpha = 0;
    CGFloat ipx = IS_IPHONE_X()?34:0;
    CGFloat H = 525+ipx;
    self.cornalView.frame = CGRectMake(0, ScreenH, ScreenW, H);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 1;
        self.cornalView.frame = CGRectMake(0, ScreenH-H, ScreenW, H);
//        self.isShow = YES;
    }];
}
- (void)dissMissCar {
  
    CGFloat ipx = IS_IPHONE_X()?34:0;
      CGFloat H = 525+ipx;
    self.bgBtn.alpha = 1;
    self.cornalView.frame = CGRectMake(0, self.cornalView.top, ScreenW,H);
    [UIView animateWithDuration:0.25 animations:^{
        self.cornalView.frame = CGRectMake(0, ScreenH, ScreenW, H);
        self.bgBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
       
    }];
}
- (void)remove {
     [self removeFromSuperview];
}
- (void)hh_setupViews {
    [self addSubview:self.bgBtn];
    [self addSubview:self.cornalView];
    [self.cornalView.layer addSublayer:self.gratlayer];
    [self.cornalView addSubview:self.sureBtn];
    
    [self.cornalView addSubview:self.closeBtn];
    [self.cornalView addSubview:self.enabledBtn];
    [self.cornalView addSubview:self.disabledBtn];
    [self.cornalView addSubview:self.indecatoImgV];
    [self.cornalView addSubview:self.lineView];
    [self.cornalView addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.showYHQValueLb];
    [self.scrollerView addSubview:self.tuijianBtn];
    [self.scrollerView addSubview:self.enableTb];
    [self.scrollerView addSubview:self.disableTb];
    
}

- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.showYHQSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFOrderShopModel class]]) {
            self.model = (HFOrderShopModel*)x;
            for (HFAvailableModel *model in self.model.selectCoupouList) {
                if (model.selected == 1) {
                    [self.selectCoupouList addObject:model];
                }
            }
            if (self.model.conpoumodel.available.count != 0) {
                [self.enabledBtn setTitle:[NSString stringWithFormat:@"可用优惠券(%ld)",self.model.conpoumodel.available.count] forState:UIControlStateNormal];
            }else {
                [self.enabledBtn setTitle:@"可用优惠券" forState:UIControlStateNormal];
            }
    
            if (self.model.conpoumodel.notAvailable.count != 0) {
                [self.disabledBtn setTitle:[NSString stringWithFormat:@"不可用优惠券(%ld)",self.model.conpoumodel.notAvailable.count] forState:UIControlStateNormal];
            }else {
               [self.disabledBtn setTitle:@"不可用优惠券" forState:UIControlStateNormal];
            }
            if(self.model.conpoumodel.couponPrice > 0){
                self.showYHQValueLb.attributedText = [HFTextCovertImage attrbuteStr:[NSString stringWithFormat:@"已使用优惠券 ¥%.f",self.model.conpoumodel.couponPrice] rangeOfArray:@[[NSString stringWithFormat:@"¥%.f",self.model.conpoumodel.couponPrice]] font:12 color:@"FF0000"];
                self.tuijianBtn.hidden = YES;
            }else {
                if (self.model.conpoumodel.available.count>0) {
                    self.showYHQValueLb.text = @"请选择优惠券";
                    self.tuijianBtn.hidden = NO;
                }else {
                    
                }
            }
            self.bgBtn.frame = CGRectMake(0, 0, ScreenW, ScreenH);
            CGFloat ipx = IS_IPHONE_X()?34:0;
            CGFloat ipx2 = IS_IPHONE_X()?54:47;
            CGFloat H = 525+ipx;
            self.cornalView.frame = CGRectMake(0, ScreenH, ScreenW, H);
            self.sureBtn.frame = CGRectMake(0, self.cornalView.height-50-ipx, ScreenW, 50);
            self.gratlayer.frame = CGRectMake(0, self.cornalView.height-50-ipx, ScreenW, 50);
            [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.tuijianBtn setTitle:@"使用推荐优惠" forState:UIControlStateNormal];
            self.sureBtn.hidden = !self.model.conpoumodel.available.count;
            self.gratlayer.hidden = !self.model.conpoumodel.available.count;
            self.enabledBtn.selected = YES;
            self.disabledBtn.selected = NO;
            self.enabledBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            self.disabledBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            self.scrollerView.contentOffset = CGPointMake(0, 0);
            CGFloat enbleBtnW = [HFUntilTool boundWithStr:self.enabledBtn.currentTitle font:14 maxSize:CGSizeMake(110, 20) ].width;
            CGFloat disablenW = [HFUntilTool boundWithStr:self.disabledBtn.currentTitle font:14 maxSize:CGSizeMake(110, 20) ].width;
            self.enabledBtn.frame = CGRectMake(73, 0, enbleBtnW, 50);
            self.closeBtn.frame = CGRectMake(ScreenW-50, 0, 50, 50);
            self.disabledBtn.frame = CGRectMake(self.enabledBtn.right+40, 0, disablenW, 50);
            self.indecatoImgV.frame = CGRectMake(0, self.disabledBtn.bottom, 73, 2);
            self.indecatoImgV.centerX = self.enabledBtn.centerX;
            self.lineView.frame = CGRectMake(0, self.indecatoImgV.bottom, ScreenW, 0.5);
       
            self.showYHQValueLb.frame = CGRectMake(15, 0, ScreenW-30, 47);
            self.tuijianBtn.frame = CGRectMake(ScreenW-15-102, 11, 102, 25);
            if (self.model.conpoumodel.available.count == 0) {
                self.scrollerView.frame = CGRectMake(0, self.lineView.bottom, ScreenW, self.cornalView.height-100+ipx2);
                self.enableTb.frame = CGRectMake(0, 0, ScreenW, self.scrollerView.height);
//                self.enableTb.backgroundColor = [UIColor whiteColor];
                 self.scrollerView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
            }else {
                self.scrollerView.frame = CGRectMake(0, self.lineView.bottom, ScreenW, self.cornalView.height-100-ipx);
                self.enableTb.frame = CGRectMake(0, 47, ScreenW, self.scrollerView.height-47);
                self.scrollerView.backgroundColor = [UIColor whiteColor];
                
               
            }
            //147 0000 0004
            //pwd123456
           
            self.disableTb.frame = CGRectMake(ScreenW, 0, ScreenW, self.scrollerView.height);
            [self.disableTb reloadData];
            [self.enableTb reloadData];
        }
       
    }];
  
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dissMissCar];
    }];
    [[self.bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dissMissCar];
    }];
    [[self.disabledBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.enabledBtn.selected = NO;
        self.disabledBtn.selected = YES;
        self.disabledBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.enabledBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.scrollerView.contentOffset = CGPointMake(ScreenW, 0);
        self.indecatoImgV.centerX = self.disabledBtn.centerX;
    }];
    [[self.enabledBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.enabledBtn.selected = YES;
        self.disabledBtn.selected = NO;
        self.enabledBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.disabledBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.scrollerView.contentOffset = CGPointMake(0, 0);
        self.indecatoImgV.centerX = self.enabledBtn.centerX;
    }];
    [[self.tuijianBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
         [self.selectCoupouList  removeAllObjects];
        self.model.selectCoupouList = [self.selectCoupouList copy];
        self.model.conpoumodel.recommend = YES;
        for (HFAvailableModel *avmodel in self.model.conpoumodel.available) {
            avmodel.selected = NO;
        }
        [self.viewModel.selectYHQSubjc sendNext:self.model];
       
        [self dissMissCar];
    }];
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.model.selectCoupouList = [self.selectCoupouList copy];
        [self.viewModel.selectYHQSubjc sendNext:self.model];
        [self.selectCoupouList  removeAllObjects];
        [self dissMissCar];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.enableTb]) {
        return self.model.conpoumodel.available.count;
    }else {
       return self.model.conpoumodel.notAvailable.count;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 105;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.enableTb]) {
        HFYHQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFYHQCellE" forIndexPath:indexPath];
        HFAvailableModel *model = self.model.conpoumodel.available[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell domessageSomething];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HFYHQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFYHQCellD" forIndexPath:indexPath];
        HFAvailableModel *model = self.model.conpoumodel.notAvailable[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell domessageSomething];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)yhqCell:(HFYHQCell *)cell model:(HFAvailableModel *)model {

    self.model.conpoumodel.recommend = NO;
    HFAvailableModel *selectModel =[self.selectCoupouList firstObject];

        if (model.selected) {
            self.model.conpoumodel.currenConpouId = -1;
            model.selected = NO;
            [self.selectCoupouList removeObject:model];
            self.showYHQValueLb.text = @"请选择优惠券";
            self.tuijianBtn.hidden = NO;
            NSLog(@"");
        }else {
            
            [self.selectCoupouList removeAllObjects];
            for (HFAvailableModel *avmodel in self.model.conpoumodel.available) {
                avmodel.selected = NO;
                avmodel.recommend = NO;
            }
            model.selected = YES;
            self.showYHQValueLb.attributedText = [HFTextCovertImage attrbuteStr:[NSString stringWithFormat:@"已使用优惠券 ¥%ld",model.discountMoney] rangeOfArray:@[[NSString stringWithFormat:@"¥%ld",model.discountMoney]] font:12 color:@"FF0000"];
            self.tuijianBtn.hidden = YES;
            self.model.conpoumodel.currenConpouId = model.couponReceiptId;;
            [self.selectCoupouList addObject:model];
        }
    

    [self.disableTb reloadData];
    [self.enableTb reloadData];
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _lineView;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = [UIColor clearColor];
    }
    return _sureBtn;
}
- (UILabel *)showYHQValueLb {
    if (!_showYHQValueLb) {
        _showYHQValueLb = [HFUIkit textColor:@"333333" font:12 numberOfLines:1];
    }
    return _showYHQValueLb;
}
- (UIButton *)tuijianBtn {
    if (!_tuijianBtn) {
        _tuijianBtn = [[UIButton alloc] init];
        [_tuijianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
        [_tuijianBtn setBackgroundImage:[UIImage imageNamed:@"yhqRectangle"] forState:UIControlStateNormal];
        _tuijianBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    }
    return _tuijianBtn;
}
- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] init];
        _scrollerView.contentSize = CGSizeMake(ScreenW*2, 0);
        _scrollerView.scrollEnabled = NO;
    }
    return _scrollerView;
}
- (UITableView *)enableTb {
    if (!_enableTb) {
        _enableTb = [HFUIkit tableViewWith:UITableViewStylePlain delegate:self cellClass:[HFYHQCell class] Identifier:@"HFYHQCellE"];
        _enableTb.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
         _enableTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _enableTb;
}
- (UITableView *)disableTb {
    if (!_disableTb) {
        _disableTb = [HFUIkit tableViewWith:UITableViewStylePlain delegate:self cellClass:[HFYHQCell class] Identifier:@"HFYHQCellD"];
        _disableTb.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _disableTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _disableTb;
}
-(UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    }
    return _bgBtn;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HFUIkit image:@"close666" selectImage:@"close666"];
    }
    return _closeBtn;
}
-(UIImageView *)indecatoImgV {
    if (!_indecatoImgV) {
        _indecatoImgV = [[UIImageView alloc] init];
        _indecatoImgV.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        _indecatoImgV.layer.cornerRadius = 1;
        _indecatoImgV.layer.masksToBounds = 1;
    }
    return _indecatoImgV;
}
- (UIButton *)disabledBtn {
    if (!_disabledBtn) {
        _disabledBtn = [HFUIkit btnWithfont:14 text:@"" titleColor:@"333333" selectTitleColor:@"000000"];
    }
    return _disabledBtn;
}
- (UIButton *)enabledBtn {
    if (!_enabledBtn) {
        _enabledBtn = [HFUIkit btnWithfont:14 text:@"" titleColor:@"333333" selectTitleColor:@"000000"];
    }
    return _enabledBtn;
}
- (UIView *)cornalView {
    if (!_cornalView) {
        _cornalView = [[UIView alloc] init];
        _cornalView.backgroundColor =[UIColor whiteColor];
    }
    return _cornalView;
}
- (CAGradientLayer *)gratlayer {
    if (!_gratlayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
//        gradientLayer.cornerRadius = 13;
//        gradientLayer.masksToBounds = YES;
        _gratlayer = gradientLayer;
        //        [self.layer addSublayer:gradientLayer];
    }
    return _gratlayer;
}
- (BOOL)isContainYQH: (NSInteger)availableId {
    NSPredicate *priecte = [NSPredicate predicateWithFormat:@"availableId = %ld",availableId];
    NSInteger c = [self.selectCoupouList filteredArrayUsingPredicate:priecte].count;
    return   [self.selectCoupouList filteredArrayUsingPredicate:priecte].count;
}
- (NSMutableArray *)selectCoupouList {
    if (!_selectCoupouList) {
        _selectCoupouList = [NSMutableArray array];
    }
    return _selectCoupouList;
}
@end
