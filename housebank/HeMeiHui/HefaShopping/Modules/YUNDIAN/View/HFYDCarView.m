//
//  HFYDCarView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDCarView.h"
#import "HFYDDetialViewModel.h"
#import "HFYDCarProductCell.h"
@interface HFYDCarView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFYDCarModel *carBigModel;
@property(nonatomic,strong)UIButton *bgBtn;
@property(nonatomic,strong)UIView *cornalView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *selectedProductLb;
@property(nonatomic,strong)UIButton *clearBtn;
@property(nonatomic,strong)NSArray *datasource;
@property(nonatomic,assign)CGFloat tabH;
@end
@implementation HFYDCarView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.bgBtn];
    [self addSubview:self.cornalView];
    [self.cornalView addSubview:self.selectedProductLb];
    [self.cornalView addSubview:self.clearBtn];
    [self.cornalView addSubview:self.tableView];
    self.bgBtn.frame = CGRectMake(0, 0, self.width, self.height);
}
- (void)hh_bindViewModel {
//    self.datasource = @[@"",@"",@"",@""];
    @weakify(self)
    [[self.bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl * _Nullable x) {
        @strongify(self)
        [self dissMissCar];
    }];
    [self.viewModel.selectCarSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFYDCarModel  *carmodel = (HFYDCarModel*)x;
        self.datasource = carmodel.productDetails;
        self.carBigModel = carmodel;
        self.cornalView.frame = CGRectMake(0, self.height, ScreenW, 40+self.carBigModel.tbHeight);
        [self.tableView reloadData];
    }];
}
- (void)showCar {
    self.bgBtn.alpha = 0;
    self.cornalView.frame = CGRectMake(0, self.height, ScreenW, 40+self.carBigModel.tbHeight);
    [UIView animateWithDuration:0.25 animations:^{
       self.bgBtn.alpha = 1;
       self.cornalView.frame = CGRectMake(0, self.height-(40+self.carBigModel.tbHeight), ScreenW, 40+self.carBigModel.tbHeight);
        self.isShow = YES;
    }];
}
- (void)dissMissCar {
    self.bgBtn.alpha = 1;
    self.cornalView.frame = CGRectMake(0, self.cornalView.top, ScreenW, 40+self.carBigModel.tbHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.cornalView.frame = CGRectMake(0, self.height, ScreenW, 40+self.carBigModel.tbHeight);
        self.isShow = NO;
        self.bgBtn.alpha = 0;

    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFYDCarProductModel  *carmodel  = self.datasource[indexPath.row];
    
    return carmodel.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFYDCarProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFYDCarProductCell" forIndexPath:indexPath];
     HFYDCarProductModel  *carmodel  = self.datasource[indexPath.row];
    cell.carmodel = carmodel;
    [cell domessageDataSomthing];
    return cell;
    
}
-(UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _bgBtn;
}
- (UIView *)cornalView {
    if (!_cornalView) {
        _cornalView = [[UIView alloc] init];
        _cornalView.backgroundColor = [UIColor whiteColor];
    }
    return _cornalView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFYDCarProductCell class] forCellReuseIdentifier:@"HFYDCarProductCell"];
    }
    return _tableView;
}
- (UILabel *)selectedProductLb {
    if (!_selectedProductLb) {
        _selectedProductLb = [HFUIkit textColor:@"999999" font:16 numberOfLines:1];
    }
    return _selectedProductLb;
}
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [HFUIkit image:@"order_list_delete" selectImage:@"order_list_delete"];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clearBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    return _clearBtn;
}
@end
