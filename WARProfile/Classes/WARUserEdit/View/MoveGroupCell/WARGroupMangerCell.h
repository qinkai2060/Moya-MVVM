//
//  WARGroupMangerCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/15.
//

#import <UIKit/UIKit.h>
#import "WARGroupView.h"
#import "WARContactCategoryModel.h"
@class WARGroupMangerCell;
@protocol WARGroupMangerCellDelegate <NSObject>
- (void)saveEditingGroupMangerCell:(WARGroupMangerCell*)cell withModel:(WARContactCategoryModel*)model withOriginal:(BOOL)isOriginal;
@end
@interface WARGroupMangerCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,strong)WARGroupView *groupView;
@property(nonatomic,strong)WARContactCategoryModel *model;
@property(nonatomic,weak)id <WARGroupMangerCellDelegate> delegate;
- (void)setModel:(WARContactCategoryModel*)model;
@end
