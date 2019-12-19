//
//  CustomCategoryView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomCategoryView.h"

@interface CustomCategoryView()

@property (nonatomic, strong) NSMutableArray *arrBtn;

@end

@implementation CustomCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    self.headArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"已取消",@"已完成"];
    self.headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    self.headScrollView.backgroundColor = [UIColor whiteColor];
    float weight = 54 + 10*self.headArray.count + 56*(self.headArray.count - 1);
    self.headScrollView.contentSize = CGSizeMake(weight, 45);
    self.headScrollView.bounces = NO;
    [self addSubview:self.headScrollView];
    self.headScrollView.showsHorizontalScrollIndicator = NO;
    self.headScrollView.showsVerticalScrollIndicator = NO;

    for (int i = 0; i < self.headArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10000 + i;
        if (i == 0) {
            button.frame = CGRectMake(10, 8, 44, 30);
            button.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
        } else {
            button.frame = CGRectMake(54 + 10*i + 56*(i - 1), 8, 56, 30);
            button.layer.borderColor = HEXCOLOR(0xF5F5F5).CGColor;
            button.backgroundColor = HEXCOLOR(0xF5F5F5);
            [button setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
        }
        button.titleLabel.font = PFR12Font;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 0.5;
        [button setTitle:self.headArray[i] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.headScrollView addSubview:button];
        [self.arrBtn addObject: button];
    }

}
- (NSMutableArray *)arrBtn{
    if (!_arrBtn) {
        _arrBtn = [NSMutableArray array];
    }
    return _arrBtn;
}
- (void)buttonAction:(UIButton *)btn{
    NSLog(@"cococococo");
    
    for (UIButton *button in self.arrBtn) {
        button.layer.borderColor = HEXCOLOR(0xF5F5F5).CGColor;
        button.backgroundColor = HEXCOLOR(0xF5F5F5);
        [button setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    }
    btn.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
    if ([self.delegate respondsToSelector:@selector(didSelectCustomCategoryViewDelegateTilte:index:)]) {
        [self.delegate didSelectCustomCategoryViewDelegateTilte:btn.titleLabel.text index:btn.tag - 10000];
    }
}
    
@end
