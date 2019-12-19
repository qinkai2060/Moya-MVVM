//
//  HFLocationFilterBoxView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLocationFilterBoxView.h"
#import "HFConfitionIndexPath.h"
#import "HFFilterLocationModel.h"
#import "HFLocationFilterLeftCell.h"
#import "HFLocationFilterRightCell.h"
@interface HFLocationFilterBoxView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray<HFConfitionIndexPath*> *secondSelectArray;
@end
@implementation HFLocationFilterBoxView
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeLocation];
}

- (instancetype)initWithFilter:(HFShowFilterModel *)model {
    if (self = [super initWithFilter:model]) {
//        self.currentIndexpath = [HFConfitionIndexPath pathWithFirstPath:0 secondPath:0];
        self.secondSelectArray = [NSMutableArray array];
        self.model = model;
        [self initData];
        
    }
    return self;
}
- (void)initData {
    
    [self _findSelectedItem];
}
- (void)hh_setupViews {
    [self addSubview:self.coverView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.tableviewLeft];
    [self.bgView addSubview:self.tableviewRight];
    [self.bgView addSubview:self.resetBtn];
    [self.bgView addSubview:self.sureBtn];
}
- (NSInteger)_getFirstLayerIndex {
    HFConfitionIndexPath *path = [self.selectedArray lastObject];
    return path.firstPath;
}

- (void)_findSelectedItem {
    NSArray *firstLayers = self.model.dataSource;
    for (int i = 0; i < firstLayers.count ; i ++) {
        HFFilterLocationModel *firstItem = firstLayers[i];
        NSArray *secondtLayers = firstItem.dataSource;//
        for (int j = 0; j < firstItem.dataSource.count; j++) {
              HFFilterLocationModel *secondItem = secondtLayers[j];
            if (secondItem.isSelected == YES) {
                [self.secondSelectArray addObject:[HFConfitionIndexPath pathWithFirstPath:i secondPath:j]];
            }
        }
        if (firstItem.isSelected == YES) {
            NSArray *secondtLayers = firstItem.dataSource;//
            for (int j = 0; j < secondtLayers.count ; j++) {
                HFFilterLocationModel *secondItem = secondtLayers[j];
                
                if (secondItem.isSelected == YES) {
                    
                    [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:i secondPath:j]];
                
                }
            }
        }
    }
}
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^)(void))completion {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    self.sourceFrame = frame;
    CGFloat top = IS_iPhoneX ? CGRectGetMaxY(self.sourceFrame)+88:CGRectGetMaxY(self.sourceFrame)+64;
    self.frame = CGRectMake(0, top, ScreenW, ScreenH-top);
    
    [view addSubview:self];
    [self showNoneToHave];
    [UIView animateWithDuration:0.25 animations:^{
        [self dissHaveToNone];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)showNoneToHave {
    CGFloat top = IS_iPhoneX ? CGRectGetMaxY(self.sourceFrame)+88:CGRectGetMaxY(self.sourceFrame)+64;
    self.coverView.alpha = 0;
    self.coverView.frame = CGRectMake(0, 0, ScreenW, ScreenH-top);
    self.tableviewLeft.frame = CGRectMake(0, 0, 125, 0);
    self.tableviewRight.frame = CGRectMake(125, 0, ScreenW-125, 0);
    self.sureBtn.frame = CGRectMake(ScreenW*0.5,0, ScreenW*0.5, 0);
    self.resetBtn.frame = CGRectMake(0, 0, ScreenW*0.5, 0);
    self.bgView.frame = CGRectMake(0, 0, ScreenW, 0);
}
- (void)dissHaveToNone {
    self.tableviewLeft.frame = CGRectMake(0, 0, 125, self.model.viewHight);
    self.tableviewRight.frame = CGRectMake(125, 0, ScreenW-125, self.model.viewHight-50);
    self.sureBtn.frame = CGRectMake(ScreenW*0.5, self.model.viewHight-50, ScreenW*0.5, 50);
    self.resetBtn.frame = CGRectMake(0, self.model.viewHight-50, ScreenW*0.5, 50);
    
    self.bgView.frame = CGRectMake(0, 0, ScreenW,  self.model.viewHight);
    self.coverView.alpha = 1;
}
- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer*)tap {
    self.isDelete = YES;
     if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.secondSelectArray atIndex:self.model.type isDelete:YES];
    }
    [self dismissWithAnmation];
}
- (void)dismissWithAnmation {
    [self dissHaveToNone];
    [UIView animateWithDuration:0.25 animations:^{
        [self showNoneToHave];
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableviewLeft]) {
        return self.model.dataSource.count;
    }else {
        HFFilterLocationModel *bedTypeModel =  (HFFilterLocationModel*)self.model.dataSource[[self _getFirstLayerIndex]];
        return bedTypeModel.dataSource.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableviewLeft]) {
        return 45;
    }else {
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableviewRight]) {
        HFLocationFilterLeftCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"rightTAB" forIndexPath:indexPath];
        HFFilterLocationModel *model = (HFFilterLocationModel*)self.model.dataSource[[self _getFirstLayerIndex]];
        HFFilterLocationModel *smallModel = (HFFilterLocationModel*)model.dataSource[indexPath.row];
        cell.model = smallModel;
        [cell doMessageSomething];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HFLocationFilterRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTAB" forIndexPath:indexPath];
        HFFilterLocationModel *model = (HFFilterLocationModel*)self.model.dataSource[indexPath.row];
        cell.model = model;
        [cell doMessageSomething];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HFConfitionIndexPath *selectdPath = [self.selectedArray lastObject];
    if ([tableView isEqual:self.tableviewRight]) {
        if (selectdPath.secondPath == indexPath.row) return;
        //清除
        [self _resetFromSecondPath:selectdPath isSelected:NO];
    
        //设置当前类型的选中状态
        HFFilterLocationModel *currentIndex =(HFFilterLocationModel*)self.model.dataSource[selectdPath.firstPath].dataSource[indexPath.row];
        currentIndex.isSelected = YES;
        HFConfitionIndexPath *jILU = self.secondSelectArray[selectdPath.firstPath];
        jILU.secondPath = indexPath.row;
        [self.secondSelectArray replaceObjectAtIndex:selectdPath.firstPath withObject:jILU];
        
        for (HFConfitionIndexPath *index in self.secondSelectArray) {
            if (selectdPath.firstPath != index.firstPath) {
                 self.model.dataSource[index.firstPath].dataSource[index.secondPath].isSelected = NO;
                index.secondPath = 0;
                self.model.dataSource[index.firstPath].dataSource[0].isSelected = YES;
                break;
            }
        }
        //移除
        [self.selectedArray removeAllObjects];
        //添加
        [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:selectdPath.firstPath secondPath:indexPath.row]];
        
        
        [self.tableviewRight reloadData];
        
    }else {
        if ([self _getFirstLayerIndex] == indexPath.row) return;
        self.model.dataSource[selectdPath.firstPath].isSelected = NO;
        if (indexPath.row == 1) {
            // 请求数据 组装数组
            if (self.model.dataSource[indexPath.row].dataSource.count <= 0) {
                // 发送请求
            }
           
        }
        //设置现在的选中状态
        self.model.dataSource[indexPath.row].isSelected = YES;
        HFConfitionIndexPath *jiluIndex = self.secondSelectArray[indexPath.row];
        //告诉之前选中的是
        self.model.dataSource[indexPath.row].dataSource[jiluIndex.secondPath].isSelected = YES;
        //移除
        [self.selectedArray removeAllObjects];
        
        //添加
        [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:indexPath.row secondPath:jiluIndex.secondPath]];
        [self.tableviewRight reloadData];
        [self.tableviewLeft reloadData];
    }
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.secondSelectArray atIndex:self.model.type isDelete:NO];
    }
}
- (void)_resetSelectePath:(HFConfitionIndexPath *)selectdPath isSelected:(BOOL)isSelected {
    self.model.dataSource[selectdPath.firstPath].isSelected = isSelected;
    if (selectdPath.secondPath == -1) return;
    self.model.dataSource[selectdPath.firstPath].dataSource[selectdPath.secondPath].isSelected = isSelected;
}
- (void)_resetFromSecondPath:(HFConfitionIndexPath *)selectdPath isSelected:(BOOL)isSelected {
    if (selectdPath.secondPath == -1) return;
    self.model.dataSource[selectdPath.firstPath].dataSource[selectdPath.secondPath].isSelected = isSelected;
    
}
- (void)sureClick {
    [self dissHaveToNone];
    [UIView animateWithDuration:0.25 animations:^{
        [self showNoneToHave];
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.secondSelectArray atIndex:self.model.type isDelete:YES];
    }
}
- (void)show {
    [self dissHaveToNone];
    [UIView animateWithDuration:0.25 animations:^{
        [self showNoneToHave];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)cancelClick {

    for (HFFilterLocationModel *model in self.model.dataSource) {
        model.isSelected = NO;
        for (HFFilterLocationModel *secondemodel in model.dataSource) {
            secondemodel.isSelected = NO;
        }
    }
    HFConfitionIndexPath *currentSelect = [self.selectedArray lastObject];
    if (currentSelect.firstPath != 0) {
        currentSelect.firstPath = 0;
        
    }
    self.model.dataSource[currentSelect.firstPath].isSelected = YES;
    self.model.dataSource[currentSelect.firstPath].dataSource[0].isSelected = YES;
    for ( HFConfitionIndexPath *selectIndex in self.secondSelectArray) {
        selectIndex .secondPath = 0;
    }
    
    
    
    [self.tableviewLeft reloadData];
    [self.tableviewRight reloadData];
    self.isDelete = NO;

    //     [self dismissWithAnmation];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.secondSelectArray atIndex:self.model.type isDelete:NO];
    }
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"FA8C1D"];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc] init];
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"404040"];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UITableView *)tableviewLeft {
    if (!_tableviewLeft) {
        _tableviewLeft = [[UITableView alloc] init];
        _tableviewLeft.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableviewLeft.delegate = self;
        _tableviewLeft.dataSource =self;
        _tableviewLeft.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [_tableviewLeft registerClass:[HFLocationFilterLeftCell class] forCellReuseIdentifier:@"leftTAB"];
    }
    return _tableviewLeft;
}
- (UITableView *)tableviewRight {
    if (!_tableviewRight) {
        _tableviewRight = [[UITableView alloc] init];
        _tableviewRight.delegate = self;
        _tableviewRight.dataSource =self;
        _tableviewRight.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableviewRight.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [_tableviewRight registerClass:[HFLocationFilterRightCell class] forCellReuseIdentifier:@"rightTAB"];
    }
    return _tableviewRight;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
