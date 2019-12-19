//
//  CircleOfFriendUtil.h
//  housebank
//
//  Created by Qianhong Li on 2018/1/28.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleOfFriendUtil : NSObject

// 获取视频第一帧  返回UIImage类型
+ (UIImage *)getVideoPreViewImage:(NSURL *)path;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@end
