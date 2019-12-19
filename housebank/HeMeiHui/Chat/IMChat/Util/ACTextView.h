//
//  ACTextView.h
//  MCF2
//
//  Created by zhangkai on 16/4/12.
//  Copyright © 2016年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTextView : UITextView

@property(strong, nonatomic) NSString *placeHolder;
@property(strong, nonatomic) UIColor *placeHolderColor;
@property(nonatomic, strong) UIFont *placeHolderFont;

@end
