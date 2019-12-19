//
//  NoContentView.h
//  MCF2
//
//  Created by zhangkai on 16/5/18.
//  Copyright © 2016年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHNoContentView : UIView

- (instancetype)initWithImg:(UIImage *)img title:(NSString *)title subTitle:(NSString *)subTitle;

-(void)setImg:(UIImage *)img;

-(void)setTitle:(NSString *)title;

-(void)setFont:(UIFont *)font;

- (void)setSubTitle:(NSString *)subTitle;

@end
