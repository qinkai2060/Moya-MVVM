//
//  HFAddressListView.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFAddressListView.h"
#import "HFDefaultAddressCell.h"
#import "HFAddressListViewModel.h"
#import "HFAddressModel.h"
#import "HFTableViewnView.h"
@interface HFAddressListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) HFTableViewnView *tableView;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) NSArray *datasource;
@property(nonatomic,strong) HFAddressListViewModel *viewModel;
@end
@implementation HFAddressListView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFAddressListViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    [self addSubview:view];
    [self addSubview:self.tableView];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.addBtn.frame;
    gl.startPoint = CGPointMake(0.02, 0.36);
    gl.endPoint = CGPointMake(0.99, 0.36);
    gl.cornerRadius = 20;
    gl.masksToBounds = YES;
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor, (__bridge id)[UIColor colorWithHexString:@"FF2E5D"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.layer addSublayer:gl];
    [self addSubview:self.addBtn];
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        
    } else {
        
      
        
    }
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.addressSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSArray class]]) {
            self.datasource = (NSArray*)x;
            if (self.datasource.count == 0) {
                [self.tableView setErrorImage:erroImageStr text:@"暂无地址"];
            }else {
                [self.tableView haveData];
            }
            [self.tableView reloadData];
        }else {
            if (self.datasource.count == 0) {
                 [self.tableView setErrorImage:erroImageStr text:@"暂无地址"];
            }
           
        }
        
    }];
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.addNewaddressSubjc sendNext:nil];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFAddressModel *model = self.datasource[indexPath.row];
    return model.rowheght;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFDefaultAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    HFAddressModel *model = self.datasource[indexPath.row];
    cell.model = model;
    [cell doSommthing];
    @weakify(self)
    cell.didSelectPhotoBlock = ^{
      @strongify(self)
      [self.viewModel.editingOriginSubjc sendNext:model];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFAddressModel *model = self.datasource[indexPath.row];
    [self.viewModel.didSelectSubjc sendNext:model];
}
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.height-40-20, (ScreenW-20), 40)];
        _addBtn.layer.cornerRadius = 20;
        _addBtn.backgroundColor = [UIColor clearColor];
        [_addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
     
    }
    return _addBtn;
}
- (HFTableViewnView *)tableView {
    if (_tableView == nil) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 1, ScreenW, self.height-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFDefaultAddressCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
