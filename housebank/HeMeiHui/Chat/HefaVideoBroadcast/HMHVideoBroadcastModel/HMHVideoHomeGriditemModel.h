//
//  VideoHomeGriditemModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/4/26.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
// 视频首页 编辑精选等
@interface HMHVideoHomeGriditemModel : NSObject

@property (nonatomic, strong) NSString *titleText; // 编辑 精选  title

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *hits;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSString *tagType; // 置顶
//普通视频视频  播放状态（1预告、2直播中、3回放 4:已结束、）
@property (nonatomic, strong) NSNumber *videoStatus;
//视频场景类型（0普通视频|1短视频）
@property (nonatomic, strong) NSNumber *sceneType;

@property (nonatomic, strong) NSString *bottomTag; // 底部查看全部的tag值
@property (nonatomic, strong) NSString *bottomText;  // 底部的查看全部

@property (nonatomic, assign) NSInteger sectionIndexPath;
@property (nonatomic, assign) NSInteger rowIndexPath;

@end
