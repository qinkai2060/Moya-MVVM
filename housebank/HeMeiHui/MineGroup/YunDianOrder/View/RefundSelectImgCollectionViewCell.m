//
//  RefundSelectImgCollectionViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "RefundSelectImgCollectionViewCell.h"

@implementation RefundSelectImgCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_selectImg.jpg"]];
        [self addSubview:self.imgView];
        
        self.btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnClose setImage:[UIImage imageNamed:@"icon_close"] forState:(UIControlStateNormal)];
        [self.btnClose addTarget:self action:@selector(btnClose:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnClose];
        
    }
    return self;
}
- (void)btnClose:(UIButton *)btn{
    NSInteger index = btn.tag - 10000;
    if (index >= 0) {
        if ([self.delegate respondsToSelector:@selector(refundSelectImgCollectionViewCellCloseIndex:)]) {
            [self.delegate refundSelectImgCollectionViewCellCloseIndex:index];
        }
    }
  
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgView.mas_right);
        make.centerY.equalTo(self.imgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
        CGPoint stationPoint = [self.btnClose convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.btnClose.bounds, stationPoint))
        {
            view = self.btnClose;
        }
    }
    return view;
}
@end
