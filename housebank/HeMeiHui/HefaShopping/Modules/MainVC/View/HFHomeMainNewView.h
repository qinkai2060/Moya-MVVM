//
//  HFHomeMainNewView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFHomeMainViewModel.h"
#import "HFTableViewnView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFHomeMainNewView : HFView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)HFHomeMainViewModel *viewModel;
@property(nonatomic,strong)NSArray *dataSource;
- (void)shipei;
@end

NS_ASSUME_NONNULL_END
