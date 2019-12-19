//
//  HFTextField.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFTextField;
@protocol HFTextFieldDelegate <UITextFieldDelegate>

/**
 *  给textField粘贴时,不再调用- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string方法
 *  会调用此方法
 */
- (BOOL)textField:(HFTextField *)textField shouldPasteCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HFTextField : UITextField
@property (nonatomic, weak) id<HFTextFieldDelegate, UITextFieldDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
