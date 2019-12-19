//
//  HFEditingTagView.h
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFEditingTagView : HFView
@property (nonatomic,assign) BOOL selecte;
- (void)becomFirstResponder ;
- (void)enditing;
- (BOOL)isEndEdting;
@end

NS_ASSUME_NONNULL_END
