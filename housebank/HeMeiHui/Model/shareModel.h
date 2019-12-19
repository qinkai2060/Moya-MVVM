//
//  shareModel.h
//  HeMeiHui
//
//  Created by 任为 on 16/9/29.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 shareDesc: "分享描述",
	shareImageUrl: "图片地址链接",
	shareTitle: "分享标题",
	shareUrl: "链接地址"

 */
@interface shareModel : NSObject

@property (nonatomic, strong)NSString *shareDesc;
@property (nonatomic, strong)NSString *shareImageUrl;
@property (nonatomic, strong)NSString *shareTitle;
@property (nonatomic, strong)NSString *shareUrl;
@property (nonatomic, copy) NSString *shareWeixinUrl ;
@property (nonatomic, copy) NSString *longUrl;

// 用来区分是web分享 还是图片分享 图片分享为SHARE_IMAGE
@property (nonatomic, strong) NSString *shareType;

@end
