//
//  HFFinalPriceView.h
//  housebank
//
//  Created by usermac on 2018/11/1.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFFinalPriceView : HFView
@property (nonatomic, copy) void (^didPayBlock)();
- (void)isEditing:(BOOL)isEditing;
- (void)isSelected:(BOOL)isSelected isEnabled:(BOOL)isEnabled;
- (void)setPrice:(CGFloat)price;
- (CGFloat)nowPrice;
- (void)clearState:(BOOL)editing;
@end

NS_ASSUME_NONNULL_END
