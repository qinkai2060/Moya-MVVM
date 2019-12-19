//
//  CustomNaviOrderTableView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomNaviOrderTableView.h"
#import "CustomNaviOrderTableViewCell.h"
@interface CustomNaviOrderTableView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation CustomNaviOrderTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
        
    }
    return self;
}
- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgViewt = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    bgViewt.backgroundColor = [UIColor clearColor];
    [self addSubview:bgViewt];
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [bgViewt addGestureRecognizer:tap1];

    UIView *bgViewb = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONEX_SAFE_AREA_TOP_HEIGHT_88 + 1, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88)];
    bgViewb.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self addSubview:bgViewb];
    [self addSubview:self.tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [bgViewb addGestureRecognizer:tap];
    
}
- (void)setArrDate:(NSArray *)arrDate{
    _arrDate = arrDate;
    self.selectArr = [NSMutableArray array];
    for (int i = 0; i < _arrDate.count; i++) {
        if (i == 0) {
            [self.selectArr addObject:@"1"];
        } else {
            [self.selectArr addObject:@"0"];
        }
    }
    CGFloat height = 45 * _arrDate.count;
    if (height > ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 1) {
        height = ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 1;
    }
    self.tableView.frame = CGRectMake(0, IPHONEX_SAFE_AREA_TOP_HEIGHT_88 + 1, ScreenW, height);
    [self.tableView reloadData];
}
- (void)setSelectStr:(NSString *)selectStr{
    _selectStr = selectStr;
    self.selectArr = [NSMutableArray array];
    for (int i = 0; i < _arrDate.count; i++) {
        if (([_selectStr isEqualToString:@"全部订单"] && [_arrDate[i] isEqualToString:@"全部"]) || ([_arrDate[i] isEqualToString:_selectStr])) {
            [self.selectArr addObject:@"1"];
        } else {
            [self.selectArr addObject:@"0"];
        }
    }
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.arrDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomNaviOrderTableViewCell";
    
    CustomNaviOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CustomNaviOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.label.text = self.arrDate[indexPath.row];
    if (self.selectArr.count == self.arrDate.count) {
        if ([self.selectArr[indexPath.row] isEqualToString:@"1"]) {
            cell.label.textColor = HEXCOLOR(0xF3344A);
            cell.imgSelect.hidden = NO;
        } else {
            cell.label.textColor = HEXCOLOR(0x333333);
            cell.imgSelect.hidden = YES;
        }
    }
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(customNaviOrderTableViewDelegateType:index:)]) {
        [self.delegate customNaviOrderTableViewDelegateType:CustomNaviOrderTableViewClickTableSelect index:indexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IPHONEX_SAFE_AREA_TOP_HEIGHT_88 + 1, ScreenW, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 1) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (void)touchAction{
    if ([self.delegate respondsToSelector:@selector(customNaviOrderTableViewDelegateType:index:)]) {
        [self.delegate customNaviOrderTableViewDelegateType:CustomNaviOrderTableViewClickClose index:0];
    }
}
@end
