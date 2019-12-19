//
//  HFRecommendSortView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFRecommendSortView.h"
#import "HFTableViewnView.h"
#import "HFRecommendSortCell.h"
#import "HFConfitionIndexPath.h"
@interface HFRecommendSortView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)HFFilterRecommendModel *model;
@end
@implementation HFRecommendSortView
+ (void)load {
    [super registerRenderCell:[self class] messageType:HFShowFilterModelTypeSort];
}
- (instancetype)initWithFilter:(HFShowFilterModel*)model {
    if (self = [super init]) {
        self.selectedArray = [NSMutableArray array];
        self.model = (HFFilterRecommendModel*)model;
        for (int i = 0 ; i < model.dataSource.count; i++) {
            HFFilterRecommendModel *rmodel = (HFFilterRecommendModel*)model.dataSource[i];
            if (rmodel.isSelected == YES) {
                [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:i]];
            }
        }
     
        [self hh_setupViews];
        [self.tableView reloadData];
    }
    return self;
}
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^)(void))completion {
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    self.sourceFrame = frame;
    CGFloat top = IS_iPhoneX ? CGRectGetMaxY(self.sourceFrame)+88:CGRectGetMaxY(self.sourceFrame)+64;
    self.frame = CGRectMake(0, top, ScreenW, ScreenH-top);
    self.tableView.frame = CGRectMake(0, 0, ScreenW, 0);
    [view addSubview:self];
    self.coverView.alpha = 0;
    self.coverView.frame = CGRectMake(0, 0, ScreenW, ScreenH-top);

    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 0, ScreenW,  self.model.viewHight);
        self.coverView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer*)tap {
    self.isDelete = YES;
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray atIndex:self.model.type isDelete:YES];
    }
    [self dismissWithAnmation];
    
}
- (void)dismissWithAnmation {
    self.coverView.alpha = 1;
    self.tableView.frame = CGRectMake(0, 0, ScreenW, self.model.viewHight);
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, 0);
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}
- (void)hh_setupViews {
    [self addSubview:self.coverView];
    [self addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFRecommendSortCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HFRecommendSortCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HFFilterRecommendModel *model =(HFFilterRecommendModel*)self.model.dataSource[indexPath.row];
    cell.model = model;
    [cell doMessageSomething];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self _iscontainsSelectedPath:[HFConfitionIndexPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray]) {
        return;
    }else {
        for (HFFilterRecommendModel *model in self.model.dataSource) {
            model.isSelected = NO;
        }
        HFFilterRecommendModel *model = (HFFilterRecommendModel*)self.model.dataSource[indexPath.row];
        model.isSelected = YES;
        if (self.selectedArray.count) {
            [self _removePath: [HFConfitionIndexPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray];
        }
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:[HFConfitionIndexPath pathWithFirstPath:indexPath.row]];
        [tableView reloadData];
         [self dismissWithAnmation];
        self.isDelete = YES;
        if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:isDelete:)]) {
            [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray atIndex:self.model.type isDelete:YES];
        }
        
    }
 
    
}
- (BOOL)_iscontainsSelectedPath:(HFConfitionIndexPath *)path sourceArray:(NSMutableArray *)array{
    for (HFConfitionIndexPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) return YES;
    }
    return NO;
}


- (void)_removePath:(HFConfitionIndexPath *)path sourceArray:(NSMutableArray *)array {
    for (HFConfitionIndexPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) {
            [array removeObject:selectedpath];
            return;
        }
    }
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HFRecommendSortCell class] forCellReuseIdentifier:NSStringFromClass([HFRecommendSortCell class])];
        
    }
    return _tableView;
}
@end
