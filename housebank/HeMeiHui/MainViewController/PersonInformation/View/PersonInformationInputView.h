//
//  PersonInformationInputView.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonInformationInputView : UIView

@property (nonatomic,assign)UIKeyboardType keyboardType;

@property (nonatomic,copy)NSString *textMessage;

@property (nonatomic,strong)UITextField *inputFiled;

@property (nonatomic,assign)PersonInformationType currentType;


- (void)cancelKeyboard;

@end

NS_ASSUME_NONNULL_END
