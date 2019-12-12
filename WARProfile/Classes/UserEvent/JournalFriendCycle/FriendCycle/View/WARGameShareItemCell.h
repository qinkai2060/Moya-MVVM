//
//  WARGameShareItemCell.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import <UIKit/UIKit.h>
#import "WARGameShareItemModel.h"

static NSString *kWARGameShareItemCellId = @"WARGameShareItemCell";

@interface WARGameShareItemCell : UICollectionViewCell

/** item */
@property (nonatomic, strong) WARGameShareItemModel *item;

@end
