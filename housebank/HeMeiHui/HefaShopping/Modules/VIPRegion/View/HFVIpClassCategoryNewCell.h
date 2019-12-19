//
//  HFVIpClassCategoryNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFTableViewnView.h"

@class HFSegementModel;
@class HFVIPModel;
typedef void(^didNewGoodsBlock)(HFVIPModel *model) ;
NS_ASSUME_NONNULL_BEGIN

@interface HFVIpClassCategoryNewCell : UICollectionViewCell
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HFSegementModel *model;
@property(nonatomic,strong)didNewGoodsBlock didGoodsBlock;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)BOOL bottomCanscroll;
- (void)setErrorImage:(NSString *)imageStr text:(NSString*)textStr;
- (void)haveData;
@end

NS_ASSUME_NONNULL_END
