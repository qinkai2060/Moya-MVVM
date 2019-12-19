//
//  NSString+Extention.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/29.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

- (NSMutableAttributedString *)addBlank {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@.",self]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length-1)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-1,1)];
    
    return string;
}
- (NSMutableAttributedString *)addBlank3 {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@...",self]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length-3)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-3,3)];
    
    return string;
}
@end
