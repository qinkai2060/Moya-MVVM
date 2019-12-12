//
//  WARFriendCommentLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import <Foundation/Foundation.h>
#import "YYTextLayout.h"

#define kCellContentMargin 11.5
#define kCellJournalMargin 10
#define kCommentMargin 8
#define kCommentContentWidth (kScreenWidth - 63.5 - kCellContentMargin)
#define kCommentReplyCellWH          40
#define kCommentCollectionCellWH     40


@class WARFriendComment;

@interface WARFriendCommentLayout : NSObject

@property (nonatomic, strong) WARFriendComment *comment ;

/** 朋友圈 */
@property (nonatomic, assign) CGRect contentLabelF;
@property (nonatomic, strong) YYTextLayout *textLayout;
@property (nonatomic, assign) CGRect collectionViewF;
@property (nonatomic, assign) CGRect playAudioBtnF;

/** 日志详情 */
@property (nonatomic, strong) YYTextLayout *contentTextLayout;
@property (nonatomic, strong) YYTextLayout *nameTextLayout;
@property (nonatomic, assign) CGRect containerViewF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect userIconF;
@property (nonatomic, assign) CGRect timeLableF;
@property (nonatomic, assign) CGRect commentIconF;
@property (nonatomic, assign) BOOL showCommentIcon;

@property (nonatomic, assign) CGFloat cellHeight;

+ (WARFriendCommentLayout *)commentLayout:(WARFriendComment *)comment
                        openCommentLayout:(BOOL)openCommentLayout;
 

+ (WARFriendCommentLayout *)commentFollowDetailLayout:(WARFriendComment *)comment
                        openCommentLayout:(BOOL)openCommentLayout;


+ (WARFriendCommentLayout *)commentDiaryDetailLayout:(WARFriendComment *)comment
                                    openCommentLayout:(BOOL)openCommentLayout;

+ (WARFriendCommentLayout *)commentMessageListLayout:(WARFriendComment *)comment;

/** 消息列表处使用 */
@property (nonatomic, assign) BOOL isMessageListUsed;
@end
