//
//  WARFriendCommentCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import <UIKit/UIKit.h>
#import "WARFriendCommentLayout.h"
#import "YYLabel.h"

@class WARJournalCommentCell,WARMomentVoice,WARFriendCommentVoiceView;
@protocol WARJournalCommentCellDelegate <NSObject>
 
/// 图片浏览
- (void)showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index;
/// 视频播放
- (void)playVideoWithUrl:(NSString *)accountId;
/// 头像点击
- (void)tapIconWithAccountId:(NSString*)accountId;
/// 点击了 Label 的链接
- (void)cell:(UIView *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
/// 播放音频
- (void)audioPlay:(WARMomentVoice*)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView;

@end

@interface WARJournalCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id<WARJournalCommentCellDelegate> delegate;

/** commentLayout */
@property (nonatomic, strong) WARFriendCommentLayout *commentLayout;

- (void)hideCommentIcon:(BOOL)hide;

@end
