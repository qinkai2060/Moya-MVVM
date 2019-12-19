//
//  SpTypeSearchListNoContentView.m
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypeSearchListNoContentView.h"

@implementation SpTypeSearchListNoContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 120, 20, 240, 110)];
    imageView.image = [UIImage imageNamed:@"SpType_search_noContent"];
    [self addSubview:imageView];
    
    //
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame), imageView.frame.size.width, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14.0];
    lab.textColor = RGBACOLOR(153, 153, 153, 1);
    lab.text = @"抱歉，这个星球找不到呢！";
    [self addSubview:lab];
}
@end
