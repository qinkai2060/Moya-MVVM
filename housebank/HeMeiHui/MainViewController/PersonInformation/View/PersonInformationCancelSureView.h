//
//  PersonInformationCancelSureView.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelBlock)();
typedef void(^SureBlock)();

@interface PersonInformationCancelSureView : UIView

@property (nonatomic,copy)SureBlock sureBlock;

@property (nonatomic,copy)CancelBlock cancelBlock;

@property (nonatomic,copy)NSString *leftTitle;

@property (nonatomic,copy)NSString *rightTitle;

@end

NS_ASSUME_NONNULL_END
