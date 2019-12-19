//
//  UIButton+ContactButton.m
//  housebank
//
//  Created by 任为 on 2017/9/18.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "UIButton+ContactButton.h"
#import "UIColor+Hex.h"

@implementation UIButton (ContactButton)
+(UIButton*)contactButtonWithTitle:(NSString*)title Color:(NSString*)ColorStr font:(UIFont*)font{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor colorWithHexString:ColorStr]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:ColorStr] forState:UIControlStateNormal];
    button.titleLabel.font = font;

    return button;
}
@end
