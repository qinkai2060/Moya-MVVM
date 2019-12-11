//
//  WARUserPrivateStateView.h
//  WARProfile
//
//  Created by Hao on 2018/6/19.
//

#import <UIKit/UIKit.h>

typedef void(^WARUserPrivateStateViewDidClickButtonBlock)();
typedef void(^WARUserPrivateStateViewDidClickConfirmButtonBlock)(NSString *string);

@interface WARUserPrivateStateView : UIView

@property (nonatomic, copy) WARUserPrivateStateViewDidClickButtonBlock cancelBlock;
@property (nonatomic, copy) WARUserPrivateStateViewDidClickConfirmButtonBlock confirmBlock;

- (id)initWithFrame:(CGRect)frame state:(NSString *)state;

@end
