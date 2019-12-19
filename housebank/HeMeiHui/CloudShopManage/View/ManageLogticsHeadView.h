//
//  ManageLogticsHeadView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageLogticsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageLogticsHeadView : UITableViewHeaderFooterView
- (void)passScrollDataSource:(NSArray *)dataSource;
@property (nonatomic, strong) ManageLogticsModel * logticsModel;
@end

NS_ASSUME_NONNULL_END
