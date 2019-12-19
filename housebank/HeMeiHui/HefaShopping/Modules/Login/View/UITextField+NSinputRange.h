//
//  UITextField+NSinputRange.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UITextField (NSinputRange)
-(NSRange) selectedRangeCustom;
//设置光标位置
-(void) setSelectedRangeCustom:(NSRange) range;
@end

NS_ASSUME_NONNULL_END
