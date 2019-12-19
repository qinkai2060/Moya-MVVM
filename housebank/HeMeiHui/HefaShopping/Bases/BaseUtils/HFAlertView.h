//
//  HFAlertView.h
//  housebank
//
//  Created by usermac on 2018/12/18.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFAlertView;
typedef NS_ENUM(NSUInteger, HFAlertViewType) {
    HFAlertViewTypeNone ,
    HFAlertViewTypeDetail,
    HFAlertViewTypeVip,
};

typedef void(^sureBBlock)(HFAlertView *  view );
typedef void(^cancelBBlock)(HFAlertView *view);
typedef void(^vipBlock)(HFAlertView *view);
NS_ASSUME_NONNULL_BEGIN

@interface HFAlertView : UIView
@property(nonatomic,copy)sureBBlock sureblock;
@property(nonatomic,copy)cancelBBlock cancelblock;
@property(nonatomic,copy)vipBlock vipblock;
@property(nonatomic,copy)NSString *currentTitle;
+ (void)showAlertViewType:(HFAlertViewType)type title:(NSString*)title detailString:(NSString*)detail cancelTitle:(NSString*)cancelText  cancelBlock:(cancelBBlock)cancel sureTitle:(NSString*)sureText sureBlock:(sureBBlock)sure ;
+ (void)showAlertViewType:(HFAlertViewType)type title:(NSString*)title detailString:(NSString*)detail cancelTitle:(NSString*)cancelText  vipBlock:(vipBlock)vipBlock sureTitle:(NSString*)sureText sureBlock:(sureBBlock)sure;
@end

NS_ASSUME_NONNULL_END
