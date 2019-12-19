
//
//  CloudManageBtn.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudManageBtn.h"
@interface CloudManageBtn ()
@property (nonatomic, strong) CAGradientLayer *gl;
@end
@implementation CloudManageBtn


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [RACObserve(self, enabled)subscribeNext:^(id  _Nullable x) {
            if (self.enabled == YES) {
                self.gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF0000"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF2E5D"].CGColor];
            }else {
                self.gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#F16C6C"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#F16C6C"].CGColor];
            }
        }];
    }
    return self;
}

- (void)initWithLayerWidth:(NSInteger)width font:(NSInteger)font height:(NSInteger)height {

    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20;
    //渐变色
    self.gl = [CAGradientLayer layer];
    self.gl.frame = CGRectMake(0, 0, width, height);
    self.gl.startPoint = CGPointMake(0.02, 0.36);
    self.gl.endPoint = CGPointMake(0.99, 0.36);
    self.gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF0000"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF2E5D"].CGColor];
    self.gl.locations = @[@(0), @(1.0f)];
    [self.layer addSublayer:self.gl];
    self.titleLabel.font = kFONT(font);
    [self setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
}


@end
