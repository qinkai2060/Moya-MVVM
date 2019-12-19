//
//  VideoListModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/14.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHVideoListModel : NSObject
//自增Id
@property (nonatomic, strong) NSNumber * id;
//视频编号
@property (nonatomic, strong) NSString * vno;
//视频场景类型（0普通视频|1短视频）
@property (nonatomic, strong) NSNumber * sceneType;

@property (nonatomic, strong) NSString * subTitle;
// 视频标题60字
@property (nonatomic, strong) NSString * title;
//视频封面地址（图片）
@property (nonatomic, strong) NSString *coverImageUrl;

@property (nonatomic, strong) NSString * imagePath;

// 预告片
@property (nonatomic, strong) NSString * coverVideoUrl;
//视频播放地址【录播】
@property (nonatomic, strong) NSString * videoUrl;
//视频播放地址【直播】
//@property (nonatomic, strong) NSString * liveUrl;
//视频主讲人
@property (nonatomic, strong) NSString * liveSpeaker;
//视频直播主讲开始时间【直播】
@property (nonatomic, strong) NSString * liveStartTime;
//视频直播主讲结束时间【直播】
@property (nonatomic, strong) NSString * liveEndTime;
//视频播放状态（1预告、2直播中、3回放 4:已结束、）
@property (nonatomic, strong) NSNumber * videoStatus;
//内容摘要
@property (nonatomic, strong) NSString * videoAbstract;
//主要内容
@property (nonatomic, strong) NSString * videoContent;
//视频类别1
@property (nonatomic, strong) NSNumber * primaryCategory;
@property (nonatomic, strong) NSString * primaryCategoryName;
//视频类别2
@property (nonatomic, strong) NSNumber * secondaryCategory;
@property (nonatomic, strong) NSString * secondaryCategoryName;
//视频类别3
@property (nonatomic, strong) NSNumber * tertiaryCategory;
@property (nonatomic, strong) NSString * tertiaryCategoryName;
//视频标签（逗号分隔）
@property (nonatomic, strong) NSString * videoTag;
@property (nonatomic, strong) NSString *videoTagName;
//设置置顶时间
@property (nonatomic, strong) NSString * topTime;
// 视频播放时间
@property (nonatomic, strong) NSNumber *seekTime;

@property (nonatomic, strong) NSString * hits;
//视频发布时间
@property (nonatomic, strong) NSString * publishTime;
// 视频审核状态（0已发布、1已下线）
@property (nonatomic, strong) NSString * tagTypeName;

@property (nonatomic, strong) NSString *cornerSignName;

@property (nonatomic, strong) NSNumber * target;
//是否精选(0：否，1：是)
@property (nonatomic, strong) NSNumber * wellChosen;
//是否推荐(0：否，1：是)
@property (nonatomic, strong) NSNumber * recommend;
//是否置顶(0：否，1：是)
@property (nonatomic, strong) NSNumber * top;
// 是否收藏
@property (nonatomic, assign)  BOOL favorite;
// 是否下载
@property (nonatomic, assign) BOOL canDownload;
// 视频是否预约
@property (nonatomic, assign) BOOL appointment;
// 视频是否可以被分享
@property (nonatomic, assign) BOOL canBeShare;
// 课件地址
@property (nonatomic, strong) NSString *coursewareAddr;
// 观看历史时间
@property (nonatomic, strong) NSString *watchSeekTime;
// 预告距离直播时间
@property (nonatomic, strong) NSNumber *liveLeftTime;
//
@property (nonatomic, assign) BOOL isOpenSubTitle;

// ==================自定义=========================
// 列表中 搜索的关键字
@property (nonatomic, strong) NSString *searchStr;
@end
