//
//  STAddressLocationView.h
//  housebank
//
//  Created by liqianhong on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAddressLocationView : UIView

- (void)refreshViewWithAddress:(NSString *)address;
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
