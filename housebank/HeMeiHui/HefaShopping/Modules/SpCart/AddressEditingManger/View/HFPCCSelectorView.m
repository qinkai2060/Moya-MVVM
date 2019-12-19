//
//  HFPCCSelectorView.m
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPCCSelectorView.h"
#import "HFPCCSelectoryCell.h"

#import "HFPCCSelectorModel.h"
@interface HFPCCSelectorView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;


@end

@implementation HFPCCSelectorView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.tableView];
}
- (void)hh_bindViewModel {
    @weakify(self);
    [self.viewModel.regionsubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.datasource = (NSArray*)x;
      
        [self.tableView reloadData];
        
    }];
}
- (void)setDatasource:(NSArray *)datasource {
    _datasource = datasource;

//    for (HFPCCSelectorModel *model in _datasource) {
//        if ([model.name isEqualToString:self.viewModel.model.regionName]||[model.name isEqualToString:self.viewModel.model.blockName]||[model.name isEqualToString:self.viewModel.model.cityName]||[model.name isEqualToString:self.viewModel.model.townName]) {
//            model.selected = YES;
//        }
//    }
     [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFPCCSelectoryCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    HFPCCSelectorModel *model = self.datasource[indexPath.row];
    Cell.model = model;
    [Cell dosomthing];
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (HFPCCSelectorModel *model in self.datasource) {
         model.selected = NO;
    }
     HFPCCSelectorModel *model = self.datasource[indexPath.row];
     model.selected = YES;
     model.indexPath = indexPath;
    [tableView reloadData];
    [self.viewModel.didSelectregionsubject sendNext:model];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource =  self;
        [_tableView registerClass:[HFPCCSelectoryCell class] forCellReuseIdentifier:@"cellId"];
        
    }
    return _tableView;
}

@end
