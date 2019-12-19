//
//  HFBedTypeFilterBoxView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBedTypeFilterBoxView.h"
#import "HFFilterBedTypeModel.h"
#import "HFBedTypeTableViewRightCell.h"
#import "HFBedTypeTableViewLeftCell.h"
#import "HFConfitionIndexPath.h"
@interface HFBedTypeFilterBoxView ()<UITableViewDelegate,UITableViewDataSource>
//@property(nonatomic,strong)HFFilterBedTypeModel *bedModel;
@end

@implementation HFBedTypeFilterBoxView
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeBedFilter];
}
- (instancetype)initWithFilter:(HFShowFilterModel *)model {
    if (self = [super initWithFilter:model]) {
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
        HFFilterBedTypeModel *firstItem = firstLayers[i];
        NSArray *secondtLayers = firstItem.dataSource;//
        for (int j = 0; j < secondtLayers.count ; j++) {
            HFFilterBedTypeModel *secondItem = secondtLayers[j];
            
            if (secondItem.isSelected == YES) {
                
                [self.secondSelectArray addObject:[HFConfitionIndexPath pathWithFirstPath:i secondPath:j]];
            }
        }
        if (firstItem.isSelected == YES) {
            NSArray *secondtLayers = firstItem.dataSource;//
            for (int j = 0; j < secondtLayers.count ; j++) {
                HFFilterBedTypeModel *secondItem = secondtLayers[j];
                
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

    [self dismissWithAnmation];
    self.isDelete = YES;
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.secondSelectArray atIndex:self.model.type isDelete:YES];
    }
    
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
        HFFilterBedTypeModel *bedTypeModel =  (HFFilterBedTypeModel*)self.model.dataSource[[self _getFirstLayerIndex]];
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
        HFBedTypeTableViewRightCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"rightTAB" forIndexPath:indexPath];
        HFFilterBedTypeModel *model = (HFFilterBedTypeModel*)self.model.dataSource[[self _getFirstLayerIndex]];
        HFFilterBedTypeModel *smallModel = (HFFilterBedTypeModel*)model.dataSource[indexPath.row];
        cell.bedModel = smallModel;
        [cell doMessageSomething];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        HFBedTypeTableViewLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTAB" forIndexPath:indexPath];
        HFFilterBedTypeModel *model = (HFFilterBedTypeModel*)self.model.dataSource[indexPath.row];
        cell.bedModel = model;
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
         //设置现在的选中状态
         HFFilterBedTypeModel *currentIndex =(HFFilterBedTypeModel*)self.model.dataSource[selectdPath.firstPath].dataSource[indexPath.row];
         currentIndex.isSelected = YES;
         HFConfitionIndexPath *jILU = self.secondSelectArray[selectdPath.firstPath];
         jILU.secondPath = indexPath.row;
         [self.secondSelectArray replaceObjectAtIndex:selectdPath.firstPath withObject:jILU];
         //移除
         [self.selectedArray removeAllObjects];
         //添加
         [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:selectdPath.firstPath secondPath:indexPath.row]];
         

         [self.tableviewRight reloadData];
        
     }else {
         if ([self _getFirstLayerIndex] == indexPath.row) return;
          self.model.dataSource[selectdPath.firstPath].isSelected = NO;
         
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
//    if (selectdPath.thirdPath == -1) return;
//    self.model.dataSource[selectdPath.firstPath].dataSource[selectdPath.secondPath].dataSource[selectdPath.thirdPath].isSelected = isSelected;
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
        self.isDelete = YES;
        [self dismiss];
    }];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
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
    self.isDelete = NO;
    for (HFFilterBedTypeModel *model in self.model.dataSource) {
        model.isSelected = NO;
        for (HFFilterBedTypeModel *secondemodel in model.dataSource) {
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
        [_tableviewLeft registerClass:[HFBedTypeTableViewLeftCell class] forCellReuseIdentifier:@"leftTAB"];
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
        [_tableviewRight registerClass:[HFBedTypeTableViewRightCell class] forCellReuseIdentifier:@"rightTAB"];
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
