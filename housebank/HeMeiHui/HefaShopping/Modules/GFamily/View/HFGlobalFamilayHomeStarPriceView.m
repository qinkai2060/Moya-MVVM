//
//  HFStarFilterBoxView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalFamilayHomeStarPriceView.h"
#import "HFConfitionIndexPath.h"

#import "HFPriceFilterCell.h"
#import "HFStarFilterCell.h"

@interface HFGlobalFamilayHomeStarPriceView()<UITableViewDelegate,UITableViewDataSource,HFStarFilterCellDelegate,HFPriceFilterCellDelegate>
@property(nonatomic,strong)NSMutableArray<HFConfitionIndexPath*> *secondSelectArray;
@end
@implementation HFGlobalFamilayHomeStarPriceView

- (instancetype)initWithFrame:(CGRect)frame WithFilter:(HFFilterPriceModel *)model {
    if (self = [super initWithFrame:frame]) {

          self.model = model;
        [self hh_setupViews];
        self.backgroundColor = [UIColor clearColor];
        CGFloat tabH = IS_iPhoneX ? 34:0;
        self.bgView.frame = frame;
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.frame = CGRectMake(0, ScreenH, ScreenW, model.viewHight+tabH);
        self.sureBtn.frame = CGRectMake(ScreenW*0.5, self.coverView.height-50-tabH, ScreenW*0.5, 50);
        self.resetBtn.frame = CGRectMake(0, self.coverView.height-50-tabH, ScreenW*0.5, 50);
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.resetBtn.bottom);
    }
    return self;
}
- (void)showStarPriceView:(NSString*)low high:(NSString*)high star:(NSString*)star {
   
     self.model.minfloat = low;
     self.model.maxfloat = (high.length == 0 ||[high isEqualToString:@"不限"] ) ?@"不限":high;
    HFFilterPriceModel *first = (HFFilterPriceModel*)[self.model.dataSource firstObject];
    first.minfloat = low;
    first.maxfloat = (high.length == 0 ||[high isEqualToString:@"不限"] ) ?@"不限":high;
    if (star.length != 0) {
            HFFilterPriceModel *last  = (HFFilterPriceModel*)[self.model.dataSource lastObject];
        for (HFFilterPriceModel *lastWithFirst in last.dataSource) {
            lastWithFirst.isSelected = NO;
        }
        if ([star isEqualToString:@"1,2,3,4,5"]) {
     
            HFFilterPriceModel *lastWithFirst =  (HFFilterPriceModel*)[last.dataSource firstObject];
            lastWithFirst.isSelected = YES;
        }else {
            for (HFFilterPriceModel *lastWithFirst in last.dataSource) {
                for (NSString *str in [star componentsSeparatedByString:@","] ) {
                    if ([lastWithFirst.codeTile isEqualToString:str]) {
                       lastWithFirst.isSelected = YES;
                    }else {
                        lastWithFirst.isSelected = NO;;
                    }
                }
            }
        }
    }
}
- (void)hh_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.tableView];
    [self.coverView addSubview:self.resetBtn];
    [self.coverView addSubview:self.sureBtn];
}

- (void)show {
    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor clearColor];
    CGFloat tabH = IS_iPhoneX ? 34:0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.coverView.frame = CGRectMake(0, ScreenH-self.model.viewHight-tabH, ScreenW, self.model.viewHight+tabH);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dissMiss {
    self.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    CGFloat tabH = IS_iPhoneX ? 34:0;
    [UIView animateWithDuration:0.25 animations:^{
            self.bgView.backgroundColor = [UIColor clearColor];
       
        self.coverView.frame = CGRectMake(0, ScreenH, ScreenW, self.model.viewHight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)showNoneToHave {
  //  CGFloat top = IS_iPhoneX ? CGRectGetMaxY(self.sourceFrame)+88:CGRectGetMaxY(self.sourceFrame)+64;
    self.coverView.alpha = 0;
  //  self.coverView.frame = CGRectMake(0, 0, ScreenW, ScreenH-top);
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
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        HFFilterPriceModel*model2 = (HFFilterPriceModel*) self. model;
        model2.minfloat = model.minfloat;
        model2.maxfloat = model.maxfloat;
        model2.selectTitle = model.selectTitle;
        self.model = model2;
    }
}

- (void)starFilterCell:(HFStarFilterCell *)cell selectArray:(NSArray *)selectArray {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        NSMutableArray *temParray = [NSMutableArray array];
        NSMutableArray *strArray = [NSMutableArray array];
        for (HFFilterPriceModel *model in selectArray) {
            [temParray addObject:[NSString stringWithFormat:@"%ld",model.star]];
            [strArray addObject:model.title];
        }
        HFFilterPriceModel *priceModle = (HFFilterPriceModel*)self.model;
        
    
        priceModle.starSelect = [temParray componentsJoinedByString:@","];
        if ([priceModle.starSelect isEqualToString:@"1,2,3,4,5"]) {
                priceModle.starSelectTitle = @"不限";
        }else {
                priceModle.starSelectTitle = [strArray componentsJoinedByString:@","];
        }
        self.model = priceModle;
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer*)tap {

        [self dissMiss];
        if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
            [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type];
        }

    
}
- (void)sureClick {
    [self dissMiss];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type];
    }
}
- (void)cancelClick {

    self.model = [HFFilterPriceModel priceStarData2];
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:@[self.model] atIndex:self.model.type];
    }
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor whiteColor];
    
    }
    return _coverView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
        tap.numberOfTouchesRequired = 1; //手指数
        tap.numberOfTapsRequired = 1; //tap次数
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
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
