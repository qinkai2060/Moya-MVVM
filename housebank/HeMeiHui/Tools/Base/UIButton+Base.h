//
//  UIButton+Base.h
//  zzw
//
//  Created by weixing on 14-11-20.
//  Copyright (c) 2014年 weixing. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIButton (Base)
@property (nonatomic, assign) BOOL underlineNone;

-(void) selectImageWithNoSelectImage:(NSString *)selectImage noSelectImage:(NSString *) noSelectImage;

-(void) ischeckImageWithCheckImage:(NSString *) isCheckImage  checkImage:(NSString *) checkImage;
-(void) normalImage:(NSString *) imageName;


@end
