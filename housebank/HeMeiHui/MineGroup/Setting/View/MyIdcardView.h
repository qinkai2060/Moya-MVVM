//
//  MyIdcardView.h
//  gcd
//
//  Created by 张磊 on 2019/4/26.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIdCardModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^MyIdcardViewRefrenshBlock)();
@interface MyIdcardView : UIView

/**
 刷新按钮block回调
 */
@property (nonatomic, copy) MyIdcardViewRefrenshBlock refrenshBlock;

@property (nonatomic, strong) MyIdCardModel *idCardModel;
//@property (nonatomic, strong) NSString *strHeader;
@end

NS_ASSUME_NONNULL_END
