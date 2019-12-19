//
//  HFStarFilterBoxView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFStarFilterBoxView.h"
#import "HFConfitionIndexPath.h"
#import "HFFilterPriceModel.h"
#import "HFPriceFilterCell.h"
#import "HFStarFilterCell.h"

@interface HFStarFilterBoxView()<UITableViewDelegate,UITableViewDataSource,HFStarFilterCellDelegate,HFPriceFilterCellDelegate>
@property(nonatomic,strong)NSMutableArray<HFConfitionIndexPath*> *secondSelectArray;
@end
@implementation HFStarFilterBoxView
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeStar];
}
- (instancetype)initWithFilter:(HFShowFilterModel *)model {
    if (self = [super initWithFilter:model]) {
        
        self.secondSelectArray = [NSMutableArray array];
        self.model = model;

        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.coverView];
    [self addSubview:self.tableView];
    [self addSubview:self.resetBtn];
    [self addSubview:self.sureBtn];
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
    self.tableView.frame = CGRectMake(0, 0, ScreenW, 0);
    self.sureBtn.frame = CGRectMake(ScreenW*0.5,0, ScreenW*0.5, 0);
    self.resetBtn.frame = CGRectMake(0, 0, ScreenW*0.5, 0);
}
- (void)dissHaveToNone {
    self.tableView.frame = CGRectMake(0, 0, ScreenW, self.model.viewHight);
    self.sureBtn.frame = CGRectMake(ScreenW*0.5, self.model.viewHight, ScreenW*0.5, 50);
    self.resetBtn.frame = CGRectMake(0, self.model.viewHight, ScreenW*0.5, 50);
    self.coverView.alpha = 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFilterPriceModel *model = (HFFilterPriceModel*)self.model.dataSource[indexPath.row];
    return model.viewHight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFilterPriceModel *model = (HFFilterPriceModel*)self.model.dataSource[indexPath.row];
    if (indexPath.row  == 0) {
        HFPriceFilterCell *Cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HFPriceFilterCell class]) forIndexPath:indexPath];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.delegate = self;
        Cell.pricefilterModel = model;
        [Cell doMessageSomthing];
        return Cell;
    }else {
        HFStarFilterCell *Cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HFStarFilterCell class]) forIndexPath:indexPath];
        Cell.delegate = self;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.starfilterModel = model;
        [Cell doSomthing];
        return Cell;
    }
    
    return nil;
}
- (void)priceFilterCell:(HFPriceFilterCell *)cell model:(HFFilterPriceModel *)model {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        HFFilterPriceModel*model2 = (HFFilterPriceModel*) self. model;
        model2.minfloat = model.minfloat;
        model2.maxfloat = model.maxfloat;
        self.model = model2;
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:HFShowFilterModelTypeStar isDelete:NO];
    }
}

- (void)starFilterCell:(HFStarFilterCell *)cell selectArray:(NSArray *)selectArray {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        NSMutableArray *temParray = [NSMutableArray array];
        for (HFFilterPriceModel *model in selectArray) {
            [temParray addObject:[NSString stringWithFormat:@"%ld",model.star]];
        }
        HFFilterPriceModel *priceModle = (HFFilterPriceModel*)self.model;
        priceModle.starSelect = [temParray componentsJoinedByString:@","];
        self.model = priceModle;
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:HFShowFilterModelTypeStar isDelete:NO];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer*)tap {
    self.isDelete = YES;
    [self dissHaveToNone];
    [UIView animateWithDuration:0.25 animations:^{
        [self showNoneToHave];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
            [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type isDelete:YES];
        }
        [self dismiss];
    }];
}
- (void)sureClick {
    [self dissHaveToNone];
    [UIView animateWithDuration:0.25 animations:^{
        [self showNoneToHave];
    } completion:^(BOOL finished) {
         [self dismiss];
    }];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type isDelete:YES];
    }
}
- (void)cancelClick {
    self.isDelete = NO;
    self.model = [HFFilterPriceModel priceStarData];
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type isDelete:NO];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFPriceFilterCell class] forCellReuseIdentifier:NSStringFromClass([HFPriceFilterCell class])];
        
        [_tableView registerClass:[HFStarFilterCell class] forCellReuseIdentifier:NSStringFromClass([HFStarFilterCell class])];
    }
    return _tableView;
}
@end
