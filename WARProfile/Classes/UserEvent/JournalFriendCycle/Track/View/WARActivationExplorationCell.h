//
//  WARActivationExplorationCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <UIKit/UIKit.h>
#import "WARActivationExplorationLayout.h"

@class WARActivationExplorationCell;

@protocol WARActivationExplorationCellDelegate <NSObject>
-(void)activationExplorationCell:(WARActivationExplorationCell *)cell indexPath:(NSIndexPath *)indexPath accountId:(NSString *)accountId;
@end

@interface WARActivationExplorationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id<WARActivationExplorationCellDelegate> delegate;
/** indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** layout */
@property (nonatomic, strong) WARActivationExplorationLayout *layout;

@end
