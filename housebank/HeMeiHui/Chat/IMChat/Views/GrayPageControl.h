//
//  GrayPageControl.h
//  HuangPuShoping
//
//  Created by Victor on 13-8-13.
//  Copyright (c) 2013年 @mwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrayPageControl : UIPageControl {
    UIImage* activeImage;
    UIImage* inactiveImage;
}

@property (nonatomic, retain) UIImage *inactiveImage;
@property (nonatomic, retain) UIImage *activeImage;

@end

