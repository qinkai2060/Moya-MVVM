//
//  HFYDProductView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDProductView.h"
#import "HFYDDetialViewModel.h"
#import "HFYDProductCell.h"
#import "HFYDCategoryCell.h"
#import "HFYDDetialDataModel.h"//HFYDDetialLeftDataModel
@interface HFYDProductView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HFYDProductCellDelegate>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;
@property(nonatomic,strong)NSArray *o2oProductInfo;
@end
@implementation HFYDProductView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightTableView];

}
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        self.leftTableView.contentOffset = CGPointZero;
        self.rightTableView.contentOffset = CGPointZero;
    }
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.subCanSubjc subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        self.canScroll = [x boolValue];
        
    }];
    [self.viewModel.didProductSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.canScroll = NO;
    }];
    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;

        self.o2oProductInfo = model.o2oProductInfo;
        self.leftTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.leftTableView.frame = CGRectMake(0, 0, 86, self.height);
        self.rightTableView.frame = CGRectMake(self.leftTableView.right, 0,ScreenW-self.leftTableView.right, self.height);

        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView  *tab = (UITableView*)scrollView;
    if (!self.canScroll) {
        if ([tab isEqual:self.leftTableView]) {
             [tab setContentOffset:CGPointZero];
        }
        if ([tab isEqual:self.rightTableView]) {
             [tab setContentOffset:CGPointZero];
        }
    }
    CGFloat offsetY = tab.contentOffset.y;
    if (offsetY<=0) {
        [self.viewModel.canscrollSubjc sendNext:@(YES)];
        self.canScroll = NO;
        if ([tab isEqual:self.leftTableView]) {
            [tab setContentOffset:CGPointZero];
    
        }
        if ([tab isEqual:self.rightTableView]) {
            [tab setContentOffset:CGPointZero];
        }
        
    }else {
        [self.viewModel.canscrollSubjc sendNext:@(NO)];
        self.canScroll = YES;
    }
    if ([tab isEqual:self.rightTableView]) {
        NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
        
        // 左侧 talbelView 移动到的位置 indexPath
        NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
        for (HFYDDetialLeftDataModel *model  in self.o2oProductInfo) {
            model.selected = NO;
        }
        HFYDDetialLeftDataModel *model = self.o2oProductInfo[moveToIndexpath.row];
        model.selected = YES;
        // 移动 左侧 tableView 到 指定 indexPath 居中显示
        if (moveToIndexpath) {
            [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    
        [self.leftTableView  reloadData];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.leftTableView]) {
        return 1;
    }else {
   
        return self.o2oProductInfo.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.leftTableView]) {
        
        return self.o2oProductInfo.count;
    }else {
        HFYDDetialLeftDataModel *model =    self.o2oProductInfo[section];
        return model.productList.count;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.leftTableView]) {
       HFYDDetialLeftDataModel *model =    self.o2oProductInfo[indexPath.row];
        return model.rowHight;
    }else {
        HFYDDetialLeftDataModel *model =    self.o2oProductInfo[indexPath.section];
        HFYDDetialRightDataModel *rightModel = model.productList[indexPath.row];
        return rightModel.rowHight;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.rightTableView]) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-86, 44)];
        v.backgroundColor = [UIColor whiteColor];
        UILabel *lb = [HFUIkit textColor:@"000000" blodfont:14 numberOfLines:1];
        lb.frame = CGRectMake(12, 0, v.width-12, 44);
        HFYDDetialLeftDataModel *model =    self.o2oProductInfo[section];
//        HFYDDetialRightDataModel *rightModel = model.productList[indexPath.section];
        lb.text = [NSString stringWithFormat:@"%@(%ld)",model.classificationName,model.productList.count];
        [v addSubview:lb];
        return v;
    }
  
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.rightTableView]) {
        return 44;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.leftTableView]) {
        HFYDCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFYDCategoryCell" forIndexPath: indexPath];
        HFYDDetialLeftDataModel *model =    self.o2oProductInfo[indexPath.row];
        cell.model = model;
        [cell doMessageSomthing];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HFYDProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFYDProductCell" forIndexPath: indexPath];
        HFYDDetialLeftDataModel *model =    self.o2oProductInfo[indexPath.section];
        HFYDDetialRightDataModel *rightModel = model.productList[indexPath.row];
        cell.model = rightModel;
        [cell doMessageSomething];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.leftTableView]) {
        self.canScroll = YES;
        for (HFYDDetialLeftDataModel *model  in self.o2oProductInfo) {
            model.selected = NO;
        }
        HFYDDetialLeftDataModel *model = self.o2oProductInfo[indexPath.row];
        model.selected = YES;
        [self.leftTableView  reloadData];
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}
- (void)productCell:(HFYDProductCell *)cell data:(HFYDDetialRightDataModel *)model {
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}
- (void)productCell:(HFYDProductCell *)cell loginStatus:(BOOL)islogin {
    if (!islogin) {
        [self.viewModel.loginSubjc sendNext:nil];
    }
}
- (void)productCell:(HFYDProductCell *)cell selectproductSpecifications:(HFYDDetialRightDataModel *)model {
    self.viewModel.rightModel = model;
    self.viewModel.productId = model.productId;
    [self.viewModel.selectSpecialIDCommand execute:nil];
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView  alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [_leftTableView registerClass:[HFYDCategoryCell class] forCellReuseIdentifier:@"HFYDCategoryCell"];
        
        _leftTableView.tag = 100002;
    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView  alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [_rightTableView registerClass:[HFYDProductCell class] forCellReuseIdentifier:@"HFYDProductCell"];
        _rightTableView.tag = 100003;
    }
    return _rightTableView;
}
@end
