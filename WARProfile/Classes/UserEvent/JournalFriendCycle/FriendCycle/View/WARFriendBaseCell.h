//
//  WARFriendBaseCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//


/**
 事件类型

 - WARFriendBaseCellActionTypeDidTopPop: cell topView弹框
 - WARFriendBaseCellActionTypeDidBottomPop: cell bottomView弹框
 - WARFriendBaseCellActionTypePageContent: 点击page cell内容
 - WARFriendBaseCellActionTypeScrollHorizontalPage: 水平滚动page cell内容
 - WARFriendBaseCellActionTypeFinishScrollHorizontalPage: 结束水平滚动page cell内容
 - WARFriendBaseCellActionTypeDidUserHeader: 点击用户头像
 - WARFriendBaseCellActionTypeDidTopPopAd: topView 广告 弹框
 */
typedef NS_ENUM(NSUInteger, WARFriendBaseCellActionType) {
    WARFriendBaseCellActionTypeDidTopPop = 1,
    WARFriendBaseCellActionTypeDidBottomPop = 2,
    WARFriendBaseCellActionTypeDidPageContent = 3,
    WARFriendBaseCellActionTypeScrollHorizontalPage = 4,
    WARFriendBaseCellActionTypeFinishScrollHorizontalPage = 5,
    WARFriendBaseCellActionTypeDidUserHeader = 6,
    WARFriendBaseCellActionTypeDidPraise = 7,
    WARFriendBaseCellActionTypeDidFollowComment = 8,
    WARFriendBaseCellActionTypeDidTopPopAd = 9,
};

#import <UIKit/UIKit.h> 

@class WARFriendBottomView,WARFriendTopView,WARFriendBaseCell,WARMoment,WARFeedImageComponent,WARFeedComponentContent,WARDBContactModel,WARFriendCommentView,WARFriendLikeView,WARFriendComment,WARFriendCommentVoiceView,WARMomentVoice,WARFeedLinkComponent,WARFeedGame;


@protocol WARFriendBaseCellDelegate <NSObject>

@optional

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType value:(id)value;
 
-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView;

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index;

-(void)friendBaseCellShowPop:(WARFriendBaseCell *)friendBaseCell actionType:(WARFriendBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;

-(void)friendBaseCellDidUserHeader:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model;

-(void)friendBaseCellDidNoInterest:(WARFriendBaseCell *)friendBaseCell indexPath:(NSIndexPath *)indexPath;
-(void)friendBaseCellDidAllContext:(WARFriendBaseCell *)friendBaseCell  indexPath:(NSIndexPath *)indexPath;

-(void)friendBaseCellDidDelete:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment;
-(void)friendBaseCellDidEdit:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment;
-(void)friendBaseCellDidLock:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment lock:(BOOL)lock;

/** 点赞 */

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didLink:(WARFeedLinkComponent *)linkContent;
-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didGameLink:(WARFeedLinkComponent *)linkContent;
-(void)friendBaseCellDidAllRank:(WARFriendBaseCell *)friendBaseCell game:(WARFeedGame *)game;

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didUser:(NSString *)accountId;

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell didOpen:(BOOL)open indexPath:(NSIndexPath *)indexPath ;

/** 评论 */
/// 点击评论的cell
-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell moment:(WARMoment *)moment didComment:(WARFriendComment *)comment;

-(void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell audioPlay:(WARMomentVoice *)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView;
/// 视频播放
- (void)friendBaseCell:(WARFriendBaseCell *)friendBaseCell playVideoWithUrl:(NSString *)accountId;
@end


@interface WARFriendBaseCell : UITableViewCell

@property (nonatomic, weak) id<WARFriendBaseCellDelegate> delegate;
@property (nonatomic, strong) WARMoment *moment;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WARFriendBottomView *bottomView;
@property (nonatomic, strong) WARFriendTopView *topView;
@property (nonatomic, strong) WARFriendCommentView *commentView;
@property (nonatomic, strong) WARFriendLikeView *likeView;
@property (nonatomic, strong) UIView * separatorView;

/** 箭头 */
@property (nonatomic, strong) UIImageView *arrowImageView;
  
- (void)setUpUI;
- (void)showTopView:(BOOL)show;
- (void)showBottomView:(BOOL)show;
- (void)showTopExtendView:(BOOL)show;
- (void)showBottomSeparatorView:(BOOL)show;

- (void)hideLikeView:(BOOL)hide;
- (void)hideCommentView:(BOOL)hide;
- (void)hideCellSeparatorView:(BOOL)hide;

@end
