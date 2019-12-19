//
//  HFCarMainView.h
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFCarMainView : HFView
- (void)isEditingPriceView:(BOOL)isEditing;
- (void)resetState:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
