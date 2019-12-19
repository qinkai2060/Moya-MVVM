//
//  HFVIPNewHeaderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPNewHeaderView.h"
#import "HFTableViewnView.h"
#import "HFVIPViewModel.h"
#import <AsyncDisplayKit/ASStackLayoutDefines.h>
//#import "ASCellBaseNode.h"
#import "HFSectionModel.h"
#import "HFSectionModel.h"
#import "HFDBHandler.h"
#import "HFSegementCell.h"
#import "HFHomeCollectionHeaderView.h"
#import "HFHomeNewBaseCell.h"
@interface HFVIPNewHeaderView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HFVIPViewModel *viewModel;
@end
@implementation HFVIPNewHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel =  (HFVIPViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.tableView];
    
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
        }else {
   
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HFSectionModel *model = self.dataSource[section];
    return model.dataModelSource.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HFHomeCollectionHeaderView *headerView  = [[HFHomeCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 55) WithViewModel:nil];
    HFSectionModel *model = self.dataSource[section];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.sectionModel = model;
    if (model.moduleTitle.length > 0) {
        return headerView;
    }
    return nil;
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
    HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
    if (baseModel.contenMode == HHFHomeBaseModelTypeGoodsVideo) {
        [self.viewModel.didVideoSubjc sendNext:baseModel];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSectionModel *model = self.dataSource[indexPath.section];
    HFHomeBaseModel *baseModel = model.dataModelSource[indexPath.row];
    return baseModel.rowheight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HFSectionModel *model = self.dataSource[section];
    return model.moduleTitle.length > 0 ? 45:0;
}
- (void)didSelectBrowser:(HFHomeNewBaseCell*)cell {
    @weakify(self)
    cell.didBrowserBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didBrowserSubjc sendNext:model];
    };
    
    cell.didFashionBlock = ^(HFHomeBaseModel *model) {
        @strongify(self)
        [self.viewModel.didFashionSubjc sendNext:model];
    };
    
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.tag = 10000;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
