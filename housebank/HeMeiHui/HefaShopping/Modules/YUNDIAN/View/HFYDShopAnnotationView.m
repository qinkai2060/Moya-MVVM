//
//  HFYDShopAnnotationView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDShopAnnotationView.h"
#import "HFYDShopQPView.h"
@interface HFYDShopAnnotationView()
@property(nonatomic,strong)HFYDShopQPView *view;
@end
@implementation HFYDShopAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.view = [[HFYDShopQPView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-43*2, 120) WithViewModel:nil];
        self.view.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                            -CGRectGetHeight(self.bounds) / 2.f + self.calloutOffset.y);
//        self.view.shopTitle = @"星期五社区(汶水路店)";
//        self.view.address = @"世博大道(昌里路88号)";
        [self addSubview:self.view];
    }
    return self;
}

- (void)setShopTitle:(NSString *)shopTitle {
    _shopTitle = shopTitle;
    self.view.shopTitle = shopTitle;
}
- (void)setAddress:(NSString *)address {
    _address = address;
    self.view.address = address;
}
@end
