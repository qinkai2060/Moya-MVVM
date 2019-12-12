//
//  WARLightPlayVideoCell.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/6/28.
//

#import <UIKit/UIKit.h>
@class WARLightPlayVideoCellLayout;
@class WARLightPlayVideoCell;
@class WARRecommendVideo;

@protocol WARLightPlayVideoCellDelegate <NSObject>

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)lightPlayVideoCell:(WARLightPlayVideoCell *)cell didCommentAtIndexPath:(NSIndexPath *)indexPath;
- (void)lightPlayVideoCell:(WARLightPlayVideoCell *)cell didPraiseAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WARLightPlayVideoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** WARLightPlayVideoCellLayout */
@property (nonatomic, strong) WARLightPlayVideoCellLayout *layout;

@property (nonatomic, copy) void(^playCallback)(void);

- (void)setDelegate:(id<WARLightPlayVideoCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

@end
