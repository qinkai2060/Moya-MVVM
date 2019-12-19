//
//  GetCommentListModel.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 评论列表页的model
@interface GetCommentListModel : NSObject

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *commentUserId;
@property (nonatomic, strong) NSString *commentUserName;
@property (nonatomic, strong) NSString *integratedServiceScore;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSArray *commentPictureList;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *isLike;
@property (nonatomic, strong) NSString *commentLikeCount;
@property (nonatomic, strong) NSString *commentDatetime;
@property (nonatomic, strong) NSString *buyDatetime;
@property (nonatomic, strong) NSString *buyCount;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *productDescriptionScore;
@property (nonatomic, strong) NSString *serviceAttitudeScore;
@property (nonatomic, strong) NSString *logisticsServiceScore;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *commentName;
@property (nonatomic, strong) NSString *stick;
@property (nonatomic, strong) NSString *stickDatetime;
@property (nonatomic, strong) NSString *shopsId;
@property (nonatomic, strong) NSString *commentReply;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *commentReplyUserId;
@property (nonatomic, strong) NSString *commentReplyUserName;
@property (nonatomic, strong) NSString *commentShopReply;
@property (nonatomic, strong) NSString *commentReplyCount;
@property (nonatomic, strong) NSString *currentUserId;
@property (nonatomic, strong) NSString *specifications;

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

@property (nonatomic, assign) CGFloat allImageHeight; // 获取所有图片的高（和）
@end

NS_ASSUME_NONNULL_END
