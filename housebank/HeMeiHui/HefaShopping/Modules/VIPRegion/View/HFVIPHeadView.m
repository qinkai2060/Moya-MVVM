//
//  HFVIPHeadView.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPHeadView.h"
#import "HFTableViewnView.h"
#import "HFVIPViewModel.h"
#import <AsyncDisplayKit/ASStackLayoutDefines.h>
//#import "ASCellBaseNode.h"
#import "HFSectionModel.h"
#import "HFSectionModel.h"
#import "HFDBHandler.h"
#import "HFSegementCell.h"
#import "HFHomeCollectionHeaderView.h"

@interface HFVIPHeadView ()<ASTableDelegate,ASTableDataSource>
@property(nonatomic,strong)ASTableNode *tableView;
@property(nonatomic,strong)HFVIPViewModel *viewModel;

@property(nonatomic,strong)NSArray *dataSource;
@end
@implementation HFVIPHeadView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel =  (HFVIPViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubnode:self.tableView];

}

- (void)hh_bindViewModel {
    // 绑定设置frame
    @weakify(self)
    [self.viewModel.homeMainSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
          NSMutableArray *tempArray = [NSMutableArray arrayWithArray:x];
            self.dataSource = tempArray;
            self.tableView.frame = CGRectMake(0, 0, ScreenW,[HFSectionModel headerVIPHeight:self.dataSource]);
           
            [self.tableView reloadData];
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return self.dataSource.count;
}
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    HFSectionModel *model =  self.dataSource[section];
    
    return model.dataModelSource.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HFHomeCollectionHeaderView *headerView  = [[HFHomeCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 55) WithViewModel:nil];
    HFSectionModel *model = self.dataSource[section];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.sectionModel = model;
    if (model.isModuleTitleShow == YES) {
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     HFSectionModel *model = self.dataSource[section];
    if (model.isModuleTitleShow) {
        return 45;
    }
    return 0;
}
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
   
        HFSectionModel *model = self.dataSource[indexPath.section];
        HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
        ASCellBaseNode* cell = NULL;
        Class renderClass = [ASCellBaseNode getRenderClassByMessageType:baseModel.contenMode];
        if (!renderClass) {
            return [ASCellBaseNode new];
        }
        cell = [[renderClass alloc] initWithModel:model];
        if ([tableNode.js_reloadIndexPaths containsObject:indexPath]) {
            cell.neverShowPlaceholders = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cell.neverShowPlaceholders = NO;
            });
        } else {
            cell.neverShowPlaceholders = NO;
        }
        [self didSelectBrowser:cell];
        return cell;
    };
    
    return cellNodeBlock;
}
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSectionModel *model = self.dataSource[indexPath.section];
    HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
    if (baseModel.contenMode == HHFHomeBaseModelTypeGoodsVideo) {
        [self.viewModel.didVideoSubjc sendNext:baseModel];
    }
}
- (void)didSelectBrowser:(ASCellBaseNode*)cell {
    @weakify(self)
    cell.didBrowserBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didBrowserSubjc sendNext:model];
    };

    cell.didFashionBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didFashionSubjc sendNext:model];
    };
    cell.didVideoBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didVideoSubjc sendNext:model];
    };

  
}


- (ASTableNode *)tableView {
    if (!_tableView) {
        _tableView = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.view.scrollEnabled = NO;
        _tableView.leadingScreensForBatching = 1;
    }
    return _tableView;
}
@end
