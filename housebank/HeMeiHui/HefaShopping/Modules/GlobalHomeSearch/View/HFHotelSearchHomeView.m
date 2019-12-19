//
//  HFHotelSearchHomeView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHotelSearchHomeView.h"
#import "HFGlobalFamilyViewModel.h"
#import "HFHistoryModel.h"
#import "HFSearchKeyCell.h"
#import "CustomPasswordAlter.h"
@interface HFHotelSearchHomeView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HFGlobalFamilyViewModel *viewModel;
@property(nonatomic,strong)NSArray<HFHistoryModel*> *dataSource;

@end
@implementation HFHotelSearchHomeView

- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        HFHistoryModel *keyModel = [[HFHistoryModel alloc] init];
        keyModel.dataSource = @[];
        HFHistoryModel *historyModel = [[HFHistoryModel alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"] isKindOfClass:[NSArray class]]) {
            NSArray *array =    [[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSString *key in array) {
                HFHistoryModel *model = [[HFHistoryModel alloc] init];
                model.historyStr = key;
                [tempArray addObject:model];
            }
            NSArray *pArray = @[@"是",@"shui",@"saa"];
            NSLog(@"😝啦🌶%@",[[[pArray rac_sequence] map:^id (id value){
                return [NSString stringWithFormat:@"%@",value];
            }] foldLeftWithStart:@"" reduce:^id (id accumulator, id value){
                return [accumulator stringByAppendingString:value];
            }]);
            historyModel.dataSource =  [[tempArray reverseObjectEnumerator] allObjects];
        }else {
            historyModel.dataSource = @[];
        }
        self.dataSource = @[keyModel,historyModel];
      
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.tableView];
}
- (void)hh_bindViewModel {
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HFHistoryModel *model = self.dataSource[section];
    return model.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        HFHistoryModel *model = [self.dataSource lastObject];
        if (model.dataSource.count >0) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW-30, 40)];
            lab.text = @"历史搜索";
            lab.font = [UIFont boldSystemFontOfSize:15];
            lab.textColor = [UIColor colorWithHexString:@"333333"];
            [v addSubview:lab];
            return v;
        }
        return nil;
    }
    return nil;


}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        HFHistoryModel *model = [self.dataSource lastObject];
        if (model.dataSource.count >0) {
            return 40;
        }
        return 0;
    }
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        HFHistoryModel *model = [self.dataSource lastObject];
        if (model.dataSource.count >0) {
           return 65+24;
        }
         return 0;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(63, 24, ScreenW-63*2, 40)];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearEventAlter) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        return v;
    }
    return nil;
}
- (void)clearEventAlter{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[[UIApplication sharedApplication] keyWindow] title:@"确认删除全部历史记录?" suret:@"确定" closet:@"取消" sureblock:^{
        [self clearEvent];
    } closeblock:^{
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSearchKeyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HFSearchKeyCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HFHistoryModel *model = self.dataSource[indexPath.section];
    HFHistoryModel *model2 = model.dataSource[indexPath.row];
    cell.model = model2;
    [cell doMessgaeSomthing];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFHistoryModel *model = self.dataSource[indexPath.section];
    HFHistoryModel *model2 = model.dataSource[indexPath.row];
    [self.viewModel.getKeyWordSubjc sendNext:model2.historyStr];
    if ([self.delegate respondsToSelector:@selector(hotelSearchHomeView:searchKey:)]) {
        [self.delegate hotelSearchHomeView:self searchKey:model2];
    }
}
- (void)clearEvent{
    HFHistoryModel *model = [self.dataSource lastObject];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:model.dataSource];
    [tempArray removeAllObjects];
    model.dataSource = tempArray;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyKey"]];
        [tempArray2 removeAllObjects];
        [tempArray2 addObjectsFromArray:@[]];
        [[NSUserDefaults standardUserDefaults] setObject:tempArray2 forKey:@"historyKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.tableView reloadData];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFSearchKeyCell class] forCellReuseIdentifier:NSStringFromClass([HFSearchKeyCell class])];
    }
    return _tableView;
}
@end
