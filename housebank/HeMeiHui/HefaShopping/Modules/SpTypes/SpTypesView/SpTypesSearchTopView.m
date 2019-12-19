//
//  SpTypesSearchTopView.m
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchTopView.h"
#import "UIButton+setTitle_Image.h"
// 40
@interface SpTypesSearchTopView ()
// 判断当前销量选中时 是up还是down
@property (nonatomic, assign) BOOL isNumSelectedDown;
// 判断当前价格选中时 是up还是down
@property (nonatomic, assign) BOOL isPriceSelectedDown;

@end

@implementation SpTypesSearchTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    NSArray *btnTitle = @[@"综合",@"销量",@"价格"]; // ,@"发货地"
    for (int i = 0; i < btnTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width / btnTitle.count * i, 10, self.frame.size.width / btnTitle.count, 30);
        btn.highlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:RGBACOLOR(51, 51, 51, 1) forState:UIControlStateNormal];
        [btn setTitleColor:RGBACOLOR(243, 52, 74, 1) forState:UIControlStateSelected];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitle:btnTitle[i] forState:UIControlStateSelected];

        if (i == 0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        }
        if (i == 1 || i == 2) {
            
            [btn setImage:[UIImage imageNamed:@"SpTypes_search_UnselectedDown"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedDown"] forState:UIControlStateSelected];
            
            [btn setImagePosition:1 spacing:3];
        }
        
        btn.tag = 3000+ i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:btn];
    }
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 - 1, ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [self addSubview:lineLab];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 3000) {
        self.isNumSelectedDown = NO;
        self.isPriceSelectedDown = NO;

        if (!btn.selected) {
            btn.selected = YES;
        } else {
            btn.selected = YES;
        }
    } else if(btn.tag == 3003){
        self.isNumSelectedDown = NO;
        self.isPriceSelectedDown = NO;

        if (!btn.selected) {
            btn.selected = YES;
        } else {
            btn.selected = YES;
        }
    } else if(btn.tag == 3001){
        if (btn.selected) {
            if (self.isNumSelectedDown) {
                self.isNumSelectedDown = NO;
                [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedUp"] forState:UIControlStateSelected];
            } else {
                self.isNumSelectedDown = YES;
                [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedDown"] forState:UIControlStateSelected];
            }
        } else {
            self.isNumSelectedDown = YES;
            btn.selected = YES;
            [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedDown"] forState:UIControlStateSelected];
        }
    } else if (btn.tag == 3002){
        if (btn.selected) {
            if (self.isPriceSelectedDown) {
                self.isPriceSelectedDown = NO;
                [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedUp"] forState:UIControlStateSelected];
            } else {
                self.isPriceSelectedDown = YES;
                [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedDown"] forState:UIControlStateSelected];
            }
        } else {
            btn.selected = YES;
            self.isPriceSelectedDown = YES;
            [btn setImage:[UIImage imageNamed:@"SpTypes_search_selectedDown"] forState:UIControlStateSelected];
        }
    }
    
    if (btn.selected) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    } else {
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    for (int i = 0 ; i < 4; i++) {
        if (btn.tag != i+3000) {
            UIButton *button = (UIButton *)[self viewWithTag:i+3000];
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(topBtnClickWithTag:numState:priceState:)]) {
        [self.delegate topBtnClickWithTag:btn.tag - 3000 numState:self.isNumSelectedDown priceState:self.isPriceSelectedDown];
    }
}

- (void)preventFlicker:(UIButton *)btn{
    btn.highlighted = NO;
}

@end
