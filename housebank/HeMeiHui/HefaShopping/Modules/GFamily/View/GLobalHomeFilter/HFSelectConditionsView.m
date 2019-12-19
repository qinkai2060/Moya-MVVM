//
//  HFSelectConditionsView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSelectConditionsView.h"
#import "UIButton+HQCustomIcon.h"
#import "HFGlobalFamilyViewModel.h"

@interface HFSelectConditionsView ()
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@property(nonatomic,strong)UIButton *selectBtn;

@end
@implementation HFSelectConditionsView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    NSArray *array = @[@"价格星级",@"位置",@"筛选",@"推荐排序"];
    for (int i = 0; i <4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW/4)*i, 0, ScreenW/4, self.height-0.5)];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"FF6600"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"Triangle_down"] forState:(UIControlState)UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Triangle_up"]forState:(UIControlState)UIControlStateSelected];
        [btn setIconInRightWithSpacing:5];
        [btn addTarget:self action:@selector(didFilterClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [self addSubview:btn];

    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 43.5, ScreenW, 0.5);
    layer.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    [self.layer addSublayer:layer];
}
- (void)didFilterClick:(UIButton*)btn {
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"Triangle_down"] forState:(UIControlState)UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"FF6600"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"Triangle_up"]forState:(UIControlState)UIControlStateSelected];
    if (self.selectBtn) {
        if (![self.selectBtn isEqual:btn]) {
            self.selectBtn.imageView.transform=CGAffineTransformIdentity;
            self.selectBtn.selected = NO;
            self.selectBtn = nil;
            btn.selected = YES;
            self.selectBtn = btn;
        }else {
            [self clearBtnState];
//            if ([self.delegate respondsToSelector:@selector(selectConditionView:didDismissBtnType::)]) {
//                [self.delegate selectConditionView:self didDismissBtnType:self.selectBtn.tag];
//            }
        }
    }else {
        btn.selected = YES;
        self.selectBtn = btn;
    }
    if ([self.delegate respondsToSelector:@selector(selectConditionView:didSelectBtnType:)]) {
        [self.delegate selectConditionView:self didSelectBtnType:self.selectBtn.tag];
    }
}
- (void)clearBtnState {

        self.selectBtn.imageView.transform= CGAffineTransformRotate(self.selectBtn.imageView.transform, M_PI);//旋转180
//    }else
//    {
//        /*cell.arrowsImg.transform = CGAffineTransformRotate(cell.transform, -M_PI);//不知道为何反向旋转180没反应,希望懂得大牛给解释下.*/
//        cell.arrowsImg.transform = CGAffineTransformIdentity;//还原
//    }
//    self.selectBtn = nil;
}

@end
