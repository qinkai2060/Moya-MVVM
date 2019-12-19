//
//  TopContactsView.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "TopContactsView.h"
#import "AboutUsTableViewCell.h"
#import "UIView+addGradientLayer.h"

@interface TopContactsView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TopContactsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    [self addSubview:self.tableView];
    
    UIButton *btnAddTopContacts = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnAddTopContacts setTitle:@"+新增常用联系人" forState:(UIControlStateNormal)];
    btnAddTopContacts.titleLabel.font = PFR16Font;
    [btnAddTopContacts setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnAddTopContacts.backgroundColor = HEXCOLOR(0xFF2E5D);
    btnAddTopContacts.layer.cornerRadius = 25;
    btnAddTopContacts.layer.masksToBounds = YES;
    [btnAddTopContacts addTarget:self action:@selector(btnAddTopContactsAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnAddTopContacts];
    [btnAddTopContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-30);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(50);
    }];
    [self layoutIfNeeded];
    [btnAddTopContacts addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnAddTopContacts bringSubviewToFront:btnAddTopContacts.titleLabel];
}
- (void)btnAddTopContactsAction{
    if (self.createBlock) {
        self.createBlock();
    }
}
- (void)setArrDateSoure:(NSMutableArray *)arrDateSoure{
    _arrDateSoure = arrDateSoure;
    [self.tableView reloadData];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 110) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
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
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDateSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsTableViewCell"];
    if (!cell) {
        cell = [[AboutUsTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"AboutUsTableViewCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TopContactsModel *model = (TopContactsModel *)self.arrDateSoure[indexPath.row];
    cell.titleLabel.text = model.name;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        TopContactsModel *model = (TopContactsModel *)self.arrDateSoure[indexPath.row];
    if (self.cellBlock) {
        self.cellBlock(model);
    }
}

@end
