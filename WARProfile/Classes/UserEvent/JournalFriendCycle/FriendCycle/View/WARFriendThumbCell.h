//
//  WARFriendThumbCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import <UIKit/UIKit.h>

@class WARThumbModel,WARFriendThumbCell;

@protocol WARFriendThumbCellDelegate <NSObject>
-(void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell  didThumber:(NSString *)accountId;
-(void)friendThumbCell:(WARFriendThumbCell *)friendThumbCell  didOpen:(BOOL)open;
@end

@interface WARFriendThumbCell : UITableViewCell
/** delegate */
@property (nonatomic, weak) id<WARFriendThumbCellDelegate> delegate;

@property (nonatomic, strong) WARThumbModel *thumbModel;
@end
