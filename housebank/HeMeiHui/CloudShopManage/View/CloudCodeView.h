//
//  CloudCodeView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^codeBlock)(void);
typedef void (^dissMissBlock)(void);
@interface CloudCodeView : UIView
@property (nonatomic, copy) NSString * titleString;
@property (nonatomic, copy) codeBlock codeBlcok;
@property (nonatomic, copy) dissMissBlock missBlock;
@property (nonatomic, strong) UIImageView * codeImageView;
- (void)initWithCodeString:(NSString *)codeString codeBlock:(codeBlock)codeBlock;
- (void)popAnimation;
- (void)closeAnimation;
@end

NS_ASSUME_NONNULL_END
