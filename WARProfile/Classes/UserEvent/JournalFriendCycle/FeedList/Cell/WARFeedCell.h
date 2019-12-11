//
//  WARFeedCell.h
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "WARFeedHeader.h"
#import "WARFeedComponentLayout.h"
#import "WARFeedModel.h"

@class WARFeedCell;
@protocol WARFeedCellDelegate <NSObject>

- (void)feedCell:(WARFeedCell *)cell didComponent:(WARFeedComponentModel *)component;

@end

@interface WARFeedCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id<WARFeedCellDelegate> baseDelegate;

/** 布局对象 */
@property (nonatomic, strong) WARFeedComponentLayout *layout;

/** 布局子控件， 子类重写 */
- (void)setupSubViews;
@end
