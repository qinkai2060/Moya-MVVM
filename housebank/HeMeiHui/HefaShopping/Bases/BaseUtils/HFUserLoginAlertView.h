//
//  HFUserLoginAlertView.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFUserLoginAlertView;
typedef NS_ENUM(NSUInteger, HFUserLoginAlertViewType) {
   HFUserLoginAlertViewTypeNone ,
   HFUserLoginAlertViewTypeRegsiterProtocol,
   HFUserLoginAlertViewTypePrivate,
};
typedef void(^sureUserBlock)(HFUserLoginAlertView *  view );
typedef void(^cancelUserBlock)(HFUserLoginAlertView *view);
typedef void(^didTextView)(NSString  *string);
NS_ASSUME_NONNULL_BEGIN

@interface HFUserLoginAlertView : UIView
@property(nonatomic,copy)sureUserBlock sureblock;
@property(nonatomic,copy)cancelUserBlock cancelblock;
@property(nonatomic,copy)didTextView didTextView;

+ (void)showAlertViewType:(HFUserLoginAlertViewType)type title:(NSString*)title contextTX:(NSString *)contentUrl bottomTX:(NSString*)bottomTX bottomRangeList:(NSArray*)bottomRangeList cancelTitle:(NSString*)cancelText  cancelBlock:(cancelUserBlock)cancel sureTitle:(NSString*)sureText sureBlock:(sureUserBlock)sure  didTextView:(didTextView)didTextViewBlock;
@end

NS_ASSUME_NONNULL_END
