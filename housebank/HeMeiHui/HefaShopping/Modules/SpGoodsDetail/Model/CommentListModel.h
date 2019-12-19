//
//  CommentListModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/19.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol CommentPictureListItem

@end

@protocol ListItem

@end
NS_ASSUME_NONNULL_BEGIN
@interface CommentPictureListItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , copy) NSString              * picType;
@property (nonatomic , assign) NSInteger             commentId;
@property (nonatomic , copy) NSString              * picPath;
@property (nonatomic , assign) NSInteger             status;
@property (nonatomic , copy) NSString              * jointPictrue;

@end


@interface ListItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              integratedServiceScore;//星级
@property (nonatomic, copy) NSString                 *icon;
@property (nonatomic, copy) NSString                 *commentUserId;
@property (nonatomic, copy) NSString                 *commentUserName;
@property (nonatomic , copy) NSString                  * commentContent;
@property (nonatomic , strong) NSArray <CommentPictureListItem> * commentPictureList;
@property (nonatomic , assign) NSInteger              isLike;
@property (nonatomic , assign) NSInteger              commentLikeCount;
@property (nonatomic , copy) NSString *              commentDatetime;//时间
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              commentReplyCount;
@property (nonatomic , assign) NSInteger              currentUserId;
@property (nonatomic, copy) NSString *specifications;//颜色

@end


@interface CommentList :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              pageNum;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              startRow;
@property (nonatomic , assign) NSInteger              endRow;
@property (nonatomic , assign) NSInteger              total;
@property (nonatomic , assign) NSInteger              pages;
@property (nonatomic , strong) NSArray <ListItem>    * list;
@property (nonatomic , assign) NSInteger              firstPage;
@property (nonatomic , assign) NSInteger              prePage;
@property (nonatomic , assign) NSInteger              nextPage;
@property (nonatomic , assign) NSInteger              lastPage;
@property (nonatomic , assign) BOOL              isFirstPage;
@property (nonatomic , assign) BOOL              isLastPage;
@property (nonatomic , assign) BOOL              hasPreviousPage;
@property (nonatomic , assign) BOOL              hasNextPage;
@property (nonatomic , assign) NSInteger              navigatePages;
@property (nonatomic , strong) NSArray <NSNumber *>              * navigatepageNums;

@end


@interface CommentData :NSObject<NSCoding>
@property (nonatomic , strong) CommentList              *commentList;

@end


@interface CommentListModel :SetBaseModel
@property (nonatomic , strong) CommentData         * data;
@property (nonatomic , assign) NSInteger        total;

@end


NS_ASSUME_NONNULL_END
