//
//  PersonCenterSetingView.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "PersonCenterSetingView.h"
#import "PersonCenterSettingTableViewCell.h"

@interface PersonCenterSetingView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation PersonCenterSetingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    [self addSubview:self.tableView];
    UILabel *footerLoginOut = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 55, ScreenW, 55)];
    footerLoginOut.backgroundColor = [UIColor whiteColor];
    footerLoginOut.text = @"退出登录";
    footerLoginOut.userInteractionEnabled = YES;
    footerLoginOut.font = PFR16Font;
    footerLoginOut.textColor = HEXCOLOR(0xF3344A);
    footerLoginOut.textAlignment = NSTextAlignmentCenter;
    [self addSubview:footerLoginOut];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoginOutAction)];
    [footerLoginOut addGestureRecognizer:tap];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 55) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (void)setArrDateSoure:(NSArray *)arrDateSoure{
    _arrDateSoure = arrDateSoure;
    [self.tableView reloadData];
}
#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrDateSoure.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = HEXCOLOR(0xF5F5F5);
    return footer;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [NSArray arrayWithArray:_arrDateSoure[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCenterSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCenterSettingTableViewCell"];
    if (!cell) {
        cell = [[PersonCenterSettingTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"PersonCenterSettingTableViewCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = [NSArray arrayWithArray:_arrDateSoure[indexPath.section]];
    if (arr.count - 1 == indexPath.row) {
        cell.line.hidden = YES;
    } else {
        cell.line.hidden = NO;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:arr[indexPath.row]];
    cell.titleL.text = [dic objectForKey:@"title"];
    cell.imgLogo.image = [UIImage imageNamed:[dic objectForKey:@"logo"]] ;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [NSArray arrayWithArray:_arrDateSoure[indexPath.section]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:arr[indexPath.row]];
    if (self.setttinBlock) {
        self.setttinBlock([dic objectForKey:@"class"], PersonCenterSetingViewClickTypeCellClick);
    }
}
#pragma mark - 退出登录
- (void)tapLoginOutAction{
    if (self.setttinBlock) {
        self.setttinBlock(@"", PersonCenterSetingViewClickTypeLoginOut);
    }
}
@end
