//
//  UICutomButton.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UICutomButton.h"
@interface UICutomButton ()
@property (nonatomic,strong)CAShapeLayer *shapLayer;
@end
@implementation UICutomButton
//- (instancetype)init {
//    if (self = [super init]) {
//       // [self.layer addSublayer:self.shapLayer];
//       // [self setBackgroundImage:[UIImage imageNamed:@"special_check"] forState:UIControlStateSelected];
//    }
//    return self;
//}
- (void)layoutSubviews {
    
//    CAShapeLayer *border = [CAShapeLayer layer];
//
//    //虚线的颜色
//    border.strokeColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
//    //填充的颜色
//    border.fillColor = [UIColor whiteColor].CGColor;
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5];
//
//    //设置路径
//    border.path = path.CGPath;
//    self.shapLayer.frame = self.bounds;
//
//    //虚线的宽度
//    border.lineWidth = 1.f;
//
//    //虚线的间隔
//    border.lineDashPattern = @[@4, @2];
//    self.shapLayer = border;
//    if (self.state == UIControlStateDisabled) {
//        self.shapLayer.lineCap = @"square";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
//    }else if (self.state == UIControlStateNormal) {
//      //  self.shapLayer.lineCap = @"butt";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"999999"].CGColor;
//        self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
//    }else if (self.state == UIControlStateSelected) {
//       // self.shapLayer.lineCap = @"butt";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"E31436"].CGColor;
//
//    }
}
//- (void)setEnabled:(BOOL)enabled {
//    [super setEnabled:enabled];
//    if (enabled) {
//        self.shapLayer.lineCap = @"square";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
//         self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
//    }
//    if (enabled == NO && self.selected == NO) {
//       // self.shapLayer.lineCap = @"butt";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"999999"].CGColor;
//        self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
//    }
//    
//}
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if (selected) {
////        self.shapLayer.lineCap = @"butt";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"E31436"].CGColor;
//    }
//    if (self.enabled == NO && selected == NO) {
//      //  self.shapLayer.lineCap = @"butt";
//        self.shapLayer.strokeColor = [UIColor colorWithHexString:@"999999"].CGColor;
//        self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
//    }
//}
- (CAShapeLayer *)shapLayer {
    if (!_shapLayer) {

    
    }
    return _shapLayer;
}
@end
