//
//  WARFriendCommentMediaCCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import <UIKit/UIKit.h>
#import "WARFriendCommentLayout.h"
#import "WARMomentMedia.h"


static NSString *WARFriendCommentMediaCCellID = @"WARFriendCommentMediaCCellID";
@protocol WARFriendCommentMediaCCellDelegate <NSObject>
- (void)commentCCellPlayVideo:(WARMomentMedia *)video;
@end

@interface WARFriendCommentMediaCCell : UICollectionViewCell
@property (nonatomic, strong) WARMomentMedia* media;
@property (nonatomic, strong) UIButton* playVideoButton;  // 播放视频按钮
@property (nonatomic, weak) id <WARFriendCommentMediaCCellDelegate> delegate;
@end
