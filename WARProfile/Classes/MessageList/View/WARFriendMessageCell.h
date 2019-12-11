//
//  WARFriendMessageCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <UIKit/UIKit.h>
#import "WARFriendMessageLayout.h"

@class WARFriendMessageCell;
@class WARMomentUser;
@protocol WARFriendMessageCellDelegate <NSObject>
- (void)friendMessageCell:(WARFriendMessageCell *)cell didUser:(WARMomentUser *)user;
@end

@interface WARFriendMessageCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id<WARFriendMessageCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** layout */
@property (nonatomic, strong) WARFriendMessageLayout *layout;


@end
