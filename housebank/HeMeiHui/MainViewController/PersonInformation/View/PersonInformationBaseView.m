//
//  PersonInformationBaseView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationBaseView.h"

@implementation PersonInformationBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self setSubview];
        
        @weakify(self)
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
//            [self sendNotificationName:PersonInformationBaseViewNotification Object:@(self.currentType)];
               [self sendNotificationName:PersonInformationBaseViewNotification Object:self];
        }];
    }
    return self;
}

- (void)setSubview {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
