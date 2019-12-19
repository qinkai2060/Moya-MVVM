//
//  HFHomeMainNewView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeMainNewView.h"
#import "HFHomeNewBaseCell.h"
#import "HFSectionModel.h"
#import "HFHomeCollectionHeaderView.h"
#import "HFTimeLimitModel.h"
@implementation HFHomeMainNewView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {

    [self addSubview:self.tableView];

}
- (void)shipei {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.moudleRqSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.scrollerControlSubjc sendNext:@(NO)];
        if([x isKindOfClass:[NSNumber class]]) {
            [self.tableView setErrorImage:erroImageStr text:@"抱歉,这个星球找不到呢!"];
        }else {
            [self.tableView haveData];
            self.dataSource = (NSArray*)x;
            if (self.dataSource.count > 0) {
                for (HFSectionModel *model in self.dataSource) {
                    if (model.contentMode == HFSectionModelTimeLimitKillType && model.isModuleShow == YES) {
                        [self.viewModel.timeKillCommand execute:nil];
                    }
                    if (model.contentMode == HFSectionModelModulePopUp && model.isModuleShow == YES) {
                        [self.viewModel.didFinishLoadData sendNext:model];
                    }
                }
            }
        }
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
    }];
    [self.viewModel.timeKillSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass:[HFTimeLimitModel class]]) {
            HFTimeLimitModel *model = (HFTimeLimitModel*)x;
            if (self.dataSource.count >0) {
                for (HFSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.contentMode == HFSectionModelTimeLimitKillType && sectionModel.isModuleShow == YES){
                        sectionModel.dataModelSource = @[model];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self reloadMoreData];
    }];
}
- (void)reloadMoreData {
    [HFCarRequest navtiveSwitch];
    [self.tableView.mj_header endRefreshing];
    [self.viewModel.moudleRqCommand execute:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HFSectionModel *model = self.dataSource[section];
    return model.dataModelSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    HFSectionModel *model = self.dataSource[indexPath.section];
    HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
    HFHomeNewBaseCell* cell = NULL;
    
    Class renderClass = [HFHomeNewBaseCell getRenderClassByMessageType:baseModel.contenMode];
    if (!renderClass) {
        return [UITableViewCell new];
    }
    NSString *cellIndentifier = NSStringFromClass(renderClass);
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[renderClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=NO;
    }
    cell.model = baseModel;
    [cell doMessageRendering];
    [self didSelectBrowser:cell];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSectionModel *model = self.dataSource[indexPath.section];
    if (model.contentMode == HFSectionModelAdType) {
        [self.viewModel.didBannerSubjc sendNext:[model.dataModelSource firstObject]];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat maxOffset = 0;
    if (IS_iPhoneX) {
        maxOffset = 83;
    }else {
        maxOffset = 64;
    }
    CGFloat scale = scrollView.contentOffset.y/maxOffset;
    NSLog(@"%ld",self.tableView.mj_header.state);
    if (self.tableView.mj_header.state == 1) {
            if (scrollView.contentOffset.y <=0&&scrollView.isDragging) {
                 [self.viewModel.scrollerControlSubjc sendNext:@(YES)];
            }else {
                 [self.viewModel.scrollerControlSubjc sendNext:@(NO)];
            }
       
    }else {
        [self.viewModel.scrollerControlSubjc sendNext:@(YES)];
    }
    [self.viewModel.sendScaleSubjc sendNext:@(scale)];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
   
    
}
- (void)didSelectBrowser:(HFHomeNewBaseCell*)cell {
    @weakify(self)
    cell.didBrowserBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didBrowserSubjc sendNext:model];
    };
    cell.didGloabalBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didGloabalSubjc sendNext:model];
    };
    cell.didTimeKillBlock = ^(HFTimeLimitSmallModel *model) {
        @strongify(self)
        [self.viewModel.didTimeKillSubjc sendNext:model];
    };
    cell.didSpecialPBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didSpecialSubjc sendNext:model];
    };
    cell.didFashionBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didFashionSubjc sendNext:model];
    };
    cell.didZuberBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didZuberSubjc sendNext:model];
    };
    cell.didModuleFourBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didModuleFourSubjc sendNext:model];
    };
    cell.didModuleFiveBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didModuleFiveSubjc sendNext:model];
    };
    cell.didModuleSixBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didModuleSixSubjc sendNext:model];
    };
    cell.didNewsBlock = ^(HFHomeBaseModel *model) {
         @strongify(self)
        [self.viewModel.didNewsSubjc sendNext:model];
    };
    cell.didQuickCellBlock  = ^(HFHomeBaseModel *model) {
        @strongify(self)
         [self.viewModel.timeKillCommand execute:nil];
    };
    cell.didNewsMoreBlock = ^{
        @strongify(self)
        [self.viewModel.didNewsMoreSubjc sendNext:nil];
    };
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HFHomeCollectionHeaderView *headerView  = [[HFHomeCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 55) WithViewModel:nil];
     HFSectionModel *model = self.dataSource[section];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.sectionModel = model;

    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSectionModel *model = self.dataSource[indexPath.section];
    HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
    return baseModel.rowheight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HFSectionModel *model = self.dataSource[section];
    return model.moduleTitle.length > 0 ? 55:0;
}

- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tag = 10000;
    }
    return _tableView;
}

@end
