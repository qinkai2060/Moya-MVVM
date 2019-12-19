//
//  HMHHeFaCircleOfFriendModel.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/17.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHHeFaCircleOfFriendModel : NSObject

/** 链接图片 */
//@property(nonatomic,copy)   NSString * LinkImageUrl;
///** 链接地址 */
//@property(nonatomic,copy)   NSString * LinkUrl;
//
@property (nonatomic, strong) NSString *member;

//:<如果是分享的内容，此处是分享的根内容id>
@property (nonatomic, strong) NSString *rootId;
// <如果是分享的内容，发布类型>:"1|2" (1文章 2视频 )
@property (nonatomic, strong) NSString *rootPubType;

/** :<主键id> */
@property(nonatomic,strong) NSString * id;

@property (nonatomic, strong) NSString *shopId;

/** 发布人id*/
@property(nonatomic,strong) NSString * uid;
/** :<昵称名>*/
@property(nonatomic,strong) NSString * nickname;
/** :<头像>*/
@property(nonatomic,strong) NSString * imagePath;
/** :<主体标签名称>"孵化企业|金牌代理" */
@property(nonatomic,strong) NSString * label;
/** :<发布文章id> */
@property(nonatomic,strong) NSString * pubId;
/** :<发布日期，时间戳，需要被解析>"1511143266000" */
@property(nonatomic,strong) NSString * pubDate;
/** <发布类型>:"1|2" (1文章 2视频 3 转发) */
@property(nonatomic,strong) NSString * pubType;
/** <媒体指图片和视频，媒体类型连接，媒体个数以逗号进行分隔> */
@property(nonatomic,strong) NSString * pubMedia;
/** :<发布内容>"abcadsdfsdf */
@property(nonatomic,strong) NSString * pubContent;
/** <分享转发文字内容>"abcadsdfsdf..." */
@property(nonatomic,strong) NSString * shareContent;
/** :<如果是分享的内容，此处是分享的父内容id> */
@property(nonatomic,strong) NSString * parentId;
/** :<发布位置，地图编码之后的具体地址> */
@property(nonatomic,strong) NSString * pubPosition;
/** :<发布设备id>, */
@property(nonatomic,strong) NSString * pubDevice;
/** :<发布设备操作系统>,*/
@property(nonatomic,strong) NSString * pubDeviceOs;
/** :<浏览数，数字> */
@property(nonatomic,strong) NSString * views;
/** :<点赞数，数字>*/
@property(nonatomic,strong) NSString * likes;
/** :<转发数，数字> */
@property(nonatomic,strong) NSString * forwards;
/** :<评论数，数字> */
@property(nonatomic,strong) NSString * comments;
/** 备注 */
@property(nonatomic,strong) NSString * remark;
/** ,<店铺名，如果为空，则使用nickname>*/
@property(nonatomic,strong) NSString * shopName;
/** :<是否关注 true 关注，false非关注> */
@property(nonatomic,strong) NSString * follow;
/** :是否点赞*/
@property(nonatomic,strong) NSString * isLike;


#pragma mark ---------------- 自定义参数 -----------------
/**< 单张图片的宽度 */
@property(nonatomic, assign) CGFloat imgWith;
/**< 单张图片的高度 */
@property(nonatomic, assign) CGFloat imgHeight;
/** cell索引号 */
@property (nonatomic, assign) NSInteger cellIndex;

// 保存点赞个数
@property (nonatomic, strong) NSString *likesNum;

@property (nonatomic) BOOL isGetImgHeight;  //是否正在获取图片高度

@property (nonatomic, assign) CGFloat contentHeight;//内容的高度

@property (nonatomic, assign) BOOL isOpenComment;//内容是否展开

@property (nonatomic, assign) BOOL isFromShare; //  是否是来自分享

@property (nonatomic, assign) CGFloat allImageHeight; // 获取所有图片的高（和）

@end
