//
//  WARFriendCommentView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/4.
//

#import <UIKit/UIKit.h>

@class WARMoment,WARFriendCommentView,WARMomentVoice,WARFriendCommentVoiceView,YYLabel,WARFriendComment,WARFriendCommentLayout;


@protocol WARFriendCommentViewDelegate <NSObject>
/// 点击评论的cell
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView didComment:(WARFriendComment *)comment;
/// 图片浏览
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index;
/// 视频播放
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView playVideoWithUrl:(NSString *)accountId;
/// 头像点击
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView tapIconWithAccountId:(NSString*)accountId;
/// 点击了 Label 的链接
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
/// 播放音频
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView audioPlay:(WARMomentVoice*)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView;

@end

@interface WARFriendCommentView : UIView

/** delegate */
@property (nonatomic, weak) id<WARFriendCommentViewDelegate> delegate;

/** isMoreList */
@property (nonatomic, readonly) BOOL isMoreList;
@property (nonatomic, strong) UITableView* tableView;

//@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, strong) NSMutableArray <WARFriendCommentLayout *>*comments;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);

- (void)configMessageListBackGroundColor;

@property (nonatomic, assign) BOOL isWhiteBackgroundColor;

- (void)hideLineView:(BOOL)hide;


@end

