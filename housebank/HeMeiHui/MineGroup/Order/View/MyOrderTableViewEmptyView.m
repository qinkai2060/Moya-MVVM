//
//  MyOrderTableViewEmptyView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderTableViewEmptyView.h"

@implementation MyOrderTableViewEmptyView
+(instancetype)showMyOrderTableViewEmptyViewInSuperView:(UIView *)view{
    MyOrderTableViewEmptyView *cus = [[MyOrderTableViewEmptyView alloc] initWithFrame:view.bounds];
    [view addSubview:cus];
    return cus;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty"]];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(70);
        make.size.mas_equalTo(CGSizeMake(34, 40));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"您还没有相关订单"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}

@end
