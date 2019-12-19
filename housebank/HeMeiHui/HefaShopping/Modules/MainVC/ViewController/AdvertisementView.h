//
//  AdvertisementView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertisementView : UIView
@property (nonatomic, assign)BOOL isOpen;
@property (nonatomic, strong)UILabel  * memberLabel;
@property (nonatomic, strong)UIImageView * middleImageView;
@property (nonatomic, strong)NSString  * pagUrl;
- (void)closeAnimation;
- (void)popViewAnimation;
@end

NS_ASSUME_NONNULL_END
