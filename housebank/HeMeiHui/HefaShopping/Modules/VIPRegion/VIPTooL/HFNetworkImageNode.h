//
//  HFNetworkImageNode.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <AsyncDisplayKit/ASDisplayNode.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFNetworkImageNode : ASDisplayNode
/**
 网络地址
 */
@property (nonatomic, copy) NSURL *URL;
/**
 转场color
 */
@property (nonatomic, strong)UIColor *placeholderColor;
/**
 静态image
 */
@property (nonatomic, strong)UIImage *image;
/**
 转场时间
 */
@property (nonatomic, assign)NSTimeInterval js_placeholderFadeDuration;
/**
 空置图片
 */
@property (nonatomic, strong)UIImage *defaultImage;

@property (nonatomic, assign)CGFloat cornerRadius;
@end

NS_ASSUME_NONNULL_END
