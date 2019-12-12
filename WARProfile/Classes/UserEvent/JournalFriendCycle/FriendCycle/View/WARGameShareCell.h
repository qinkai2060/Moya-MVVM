//
//  WARGameShareCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import <UIKit/UIKit.h>
#import "WARGameShareItemModel.h"

@interface WARGameShareCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)hideLine:(BOOL)hide;

/** items */
@property (nonatomic, strong) NSMutableArray  <WARGameShareItemModel *> *items;

@end
