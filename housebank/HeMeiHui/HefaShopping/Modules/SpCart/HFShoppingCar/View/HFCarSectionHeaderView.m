//
//  HFCarSectionHeaderView.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarSectionHeaderView.h"
#import "HFCarViewModel.h"
@interface HFCarSectionHeaderView ()
@property (nonatomic,strong) UIButton *selectBtn;
//@property (nonatomic,strong) UIImageView *signImageV;
@property (nonatomic,strong) UIImageView *typesignImageV;
@property (nonatomic,strong) UILabel *typeTitleLb;
@property (nonatomic,strong) UIButton *storeBtn;
@property (nonatomic,strong) UIImageView *arrowsImageV;
@property (nonatomic,strong) UIButton *enterStoreBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) HFCarViewModel *viewModel;
@property (nonatomic,strong) HFShopingModel *dataModel;
@property (nonatomic,strong) HFPayMentViewModel *payMentViewmodel;
@property (nonatomic,strong) UILabel *loseTipsLB;
@property (nonatomic,strong) UIButton *clearBtn;
@end
@implementation HFCarSectionHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    if ([viewModel isKindOfClass:[HFCarViewModel class]]) {
        self.viewModel = viewModel;
    }else {
         self.payMentViewmodel = viewModel;
    }
   
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self addSubview:self.selectBtn];
    [self addSubview:self.typesignImageV];
    [self addSubview:self.typeTitleLb];
    [self addSubview:self.lineView];
    //    [self addSubview:self.signImageV];
    [self addSubview:self.storeBtn];
    [self addSubview:self.arrowsImageV];
    [self addSubview:self.enterStoreBtn];
    [self addSubview:self.clearBtn];
    [self addSubview:self.loseTipsLB];

    self.type = HFCarSectionHeaderViewTypeDefualt;
    
}
- (void)hh_bindViewModel {
  
    self.typesignImageV.frame = CGRectMake(self.selectBtn.right+5, (40-14)*0.5,14, 14);
    self.typeTitleLb.frame = CGRectMake(self.typesignImageV.right+5,0, 25, 40);
    self.lineView.frame = CGRectMake( self.typeTitleLb.right+10, (40-10)*0.5, 1, 10);
    //  self.signImageV.frame = CGRectMake(self.lineView.right, (40-15)*0.5,15, 15);
    CGSize sizeNum =  [self.storeBtn.currentTitle boundingRectWithSize:CGSizeMake(300, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
    self.storeBtn.frame = CGRectMake(self.lineView.right+10, 0, sizeNum.width, 40);
    self.arrowsImageV.frame = CGRectMake(self.storeBtn.right, (40-15)*0.5+1,15, 15);
    self.enterStoreBtn.frame = CGRectMake(self.storeBtn.right+5, 0, ScreenW - 40, 40);
    
}
- (void)setType:(HFCarSectionHeaderViewType)type {
    _type = type;

    if (type == HFCarSectionHeaderViewTypeDefualt) {

        self.typesignImageV.frame = CGRectMake(self.selectBtn.right+5, (40-15)*0.5,15, 15);
        self.selectBtn.hidden = NO;
        self.typeTitleLb.frame = CGRectMake(self.typesignImageV.right+8,0, 25, 40);

       
    }else {
        self.arrowsImageV.hidden = YES;
        self.selectBtn.hidden = YES;
        self.typesignImageV.frame = CGRectMake(10, (40-15)*0.5,15, 15);
        self.typeTitleLb.text = @"商城";
        self.typeTitleLb.frame = CGRectMake(self.typesignImageV.right+5,0, 25, 40);

    }
    self.typeTitleLb.frame = CGRectMake(self.typesignImageV.right+8,0, 25, 40);
    self.lineView.frame = CGRectMake( self.typeTitleLb.right+10, (40-10)*0.5, 1, 10);
    CGSize sizeNum =  [self.storeBtn.currentTitle boundingRectWithSize:CGSizeMake(300, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
    self.storeBtn.frame = CGRectMake(self.lineView.right+10, 0, sizeNum.width, 40);
    self.arrowsImageV.frame = CGRectMake(self.storeBtn.right, (40-15)*0.5+1,15, 15);
    self.enterStoreBtn.frame = CGRectMake(self.storeBtn.right+5, 0, ScreenW - 40, 40);
}
- (void)setOrdermodel:(HFOrderShopModel *)ordermodel {
    _ordermodel = ordermodel;
    [self.storeBtn setTitle:ordermodel.shopsName forState:UIControlStateNormal];
    self.typeTitleLb.text = @"商城";
    CGSize sizeNum =  [self.storeBtn.currentTitle boundingRectWithSize:CGSizeMake(300, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
    self.storeBtn.frame = CGRectMake(self.lineView.right+10, 0, sizeNum.width, 40);
    self.arrowsImageV.frame = CGRectMake(self.storeBtn.right, (40-15)*0.5+1,15, 15);
    self.enterStoreBtn.frame = CGRectMake(self.storeBtn.right+5, 0, ScreenW - 40, 40);
}
- (void)setShoppingModel:(HFShopingModel*)shoppingModel {
    NSInteger selectedCount = 0;
    for (HFStoreModel *store in shoppingModel.productList) {
        if (shoppingModel.isEditing) {
            if (store.editingRowSelected&&store.ContentMode != HFCarListTypeNoneStock) {
                selectedCount++;
            }
        }else{
            if (store.isRowSelected&&store.ContentMode != HFCarListTypeNoneStock) {
                selectedCount++;
            }
        }
    }
    if ((shoppingModel.outStockCount == shoppingModel.productList.count &&shoppingModel.productList.count!=0
             &&selectedCount==0)) {
        self.selectBtn.enabled = NO;
    }else {
        self.selectBtn.enabled = YES;
        if (shoppingModel.isEditing) {
            if (shoppingModel.totalShoppingCount == selectedCount&& selectedCount!=0) {
                shoppingModel.EditingSectionSelected = YES;
            }else {
                shoppingModel.EditingSectionSelected = NO;
            }
        }else {
            if (shoppingModel.totalShoppingCount == selectedCount&& selectedCount!=0 ) {
                shoppingModel.isSectionSelected = YES;
            }else {
                shoppingModel.isSectionSelected = NO;
            }
        }
        if (shoppingModel.isEditing) {
            self.selectBtn.selected = shoppingModel.EditingSectionSelected;
        }else {
            self.selectBtn.selected = shoppingModel.isSectionSelected;
        }
    }

  
  
    if (shoppingModel.contentMode == HFCarListTypeOverTime ) {
        self.loseTipsLB.hidden = NO;
        self.clearBtn.hidden = NO;
        self.typesignImageV.hidden = YES;
        self.storeBtn.hidden = YES;
        self.arrowsImageV.hidden = YES;
        self.enterStoreBtn.hidden = YES;
        self.lineView.hidden = YES;
        self.typeTitleLb.hidden = YES;
        self.selectBtn.hidden = YES;
        self.loseTipsLB.text = [NSString stringWithFormat:@"失效商品%ld件",shoppingModel.productList.count];
    }else {
        self.loseTipsLB.hidden = YES;
        self.clearBtn.hidden = YES;
        self.typesignImageV.hidden = NO;
        self.storeBtn.hidden = NO;
        self.arrowsImageV.hidden = NO;
        self.enterStoreBtn.hidden = NO;
        self.lineView.hidden = NO;
        self.typeTitleLb.hidden = NO;
        self.selectBtn.hidden = NO;
    }
    self.clearBtn.frame = CGRectMake(ScreenW-15-50, 0, 50, 40);
    self.loseTipsLB.frame = CGRectMake(15, 0, ScreenW-15-50-15-5, 40);
   
  
    
    [self.storeBtn setTitle:shoppingModel.shopsName forState:UIControlStateNormal];
    self.typeTitleLb.text = @"商城";
    self.dataModel = shoppingModel;
    CGSize sizeNum =  [self.storeBtn.currentTitle boundingRectWithSize:CGSizeMake(300, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
    self.storeBtn.frame = CGRectMake(self.lineView.right+10, 0, sizeNum.width, 40);
    self.arrowsImageV.frame = CGRectMake(self.storeBtn.right, (40-15)*0.5+1,15, 15);
    self.enterStoreBtn.frame = CGRectMake(self.storeBtn.right+5, 0, ScreenW - 40, 40);
    self.storeingModel = shoppingModel;
}
- (void)setShoppingModelStr:(NSString*)countStr {
    [self.storeBtn setTitle:countStr forState:UIControlStateNormal];
}
- (void)selectSectionAllClick:(UIButton*)btn {
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(btn.isSelected);
    }
}
- (void)enterStoreClick {
    if (self.type == HFCarSectionHeaderViewTypeDefualt) {
         [self.viewModel.enterStoreSubjc sendNext: self.storeingModel];
    }else {
      //   [self.payMentViewmodel.enterStoreSubjc sendNext:nil];
    }
   
}
- (void)clearClick {
    [self.viewModel.quickDeleteSubjc sendNext:self.dataModel];
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    }
    return _lineView;
}
- (UIButton *)enterStoreBtn {
    if (!_enterStoreBtn) {
        _enterStoreBtn = [[UIButton alloc] init];
        _enterStoreBtn.backgroundColor = [UIColor clearColor];
    }
    return _enterStoreBtn;
}
- (UIImageView *)typesignImageV {
    if (!_typesignImageV) {
        _typesignImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _typesignImageV.image = [UIImage imageNamed:@"HMH_Moudleicon"];
    }
    return _typesignImageV;
}
//- (UIImageView *)signImageV {
//    if (!_signImageV) {
//        _signImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _signImageV.image = [UIImage imageNamed:@"car_icon"];
//    }
//    return _signImageV;
//}
- (UIImageView *)arrowsImageV {
    if (!_arrowsImageV) {
        _arrowsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _arrowsImageV.image = [UIImage imageNamed:@"car_category"];
    }
    return _arrowsImageV;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
         [_selectBtn setImage:[UIImage imageNamed:@"car_disable_icon"] forState:UIControlStateDisabled];
        [_selectBtn addTarget:self action:@selector(selectSectionAllClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_storeBtn setTitle:@"快乐蚂蚁旗舰店" forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _storeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_storeBtn addTarget:self action:@selector(enterStoreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBtn;
}
- (UILabel *)typeTitleLb {
    if (!_typeTitleLb) {
        _typeTitleLb = [[UILabel alloc] init];
        _typeTitleLb.font = [UIFont boldSystemFontOfSize:12];
        _typeTitleLb.textColor = [UIColor blackColor];
        _typeTitleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _typeTitleLb;
}
- (UILabel *)loseTipsLB {
    if (!_loseTipsLB) {
        _loseTipsLB = [[UILabel alloc] init];
        _loseTipsLB.font = [UIFont boldSystemFontOfSize:12];
        _loseTipsLB.textColor = [UIColor blackColor];
        _loseTipsLB.hidden = YES;
    }
    return _loseTipsLB;
}
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setTitle:@"快速清理" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.hidden = YES;
    }
    return _clearBtn;
}
@end
