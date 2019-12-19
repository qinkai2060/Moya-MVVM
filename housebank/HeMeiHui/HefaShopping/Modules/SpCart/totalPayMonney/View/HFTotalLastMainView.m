//
//  HFTotalLastMainView.m
//  housebank
//
//  Created by usermac on 2018/12/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTotalLastMainView.h"
#import "HFTotalInfoView.h"
@interface HFTotalLastMainView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HFTotalInfoView *infoView;
@end
@implementation HFTotalLastMainView
- (void)hh_bindViewModel {
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height-50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //   [_tableView registerClass:[HFCarSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"sectionHeader"];
        // _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (HFTotalInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[HFTotalInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 235) WithViewModel:nil];
    }
    return _infoView;
}
@end
