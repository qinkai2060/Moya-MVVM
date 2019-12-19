//
//  CustomVipSelectTableView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomVipSelectTableView.h"
#import "CustomVipSelectTableViewCell.h"
#import "UIView+addGradientLayer.h"

@interface CustomVipSelectTableView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *bgViewt;
}
@property (nonatomic, strong) NSArray *arrDate;
@property (nonatomic, assign) CustomVipSelectTableViewType viewType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *title;
@end

@implementation CustomVipSelectTableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
+(instancetype)CustomVipSelectTableViewIn:(UIView *)view arrDate:(NSArray *)arrDate viewType:(CustomVipSelectTableViewType)viewType sureblock:(void(^)())sureblock closeblock:(void(^)())closeblock{
    CustomVipSelectTableView *cus = [[CustomVipSelectTableView alloc] initWithFrame:view.bounds];
    cus.sureblock = sureblock;
    cus.closeblock = closeblock;
    cus.viewType = viewType;
    cus.arrDate = arrDate;
    [view addSubview:cus];
    return cus;
}
- (void)setArrDate:(NSArray *)arrDate{
    _arrDate = arrDate;
    [self.tableView reloadData];
}
- (void)createView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    bgViewt = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, self.width, self.height)];
    bgViewt.backgroundColor = [UIColor clearColor];
    [self addSubview:bgViewt];
    
    
    
    [bgViewt addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt).offset(-50);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(368);
    }];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont systemFontOfSize:16];
    self.title.textColor = HEXCOLOR(0x333333);
    self.title.backgroundColor = [UIColor whiteColor];
    [bgViewt addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt).offset(-418);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(50);
        
    }];
    
    UIButton *btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSure setTitle:@"完成" forState:(UIControlStateNormal)];
    btnSure.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSure.backgroundColor = HEXCOLOR(0xFF0000);
    [btnSure addTarget:self action:@selector(touchAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bgViewt addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt);
        make.left.equalTo(bgViewt);
        make.right.equalTo(bgViewt);
        make.height.mas_equalTo(50);
    }];
    
    [self layoutIfNeeded];
    
    [btnSure addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSure bringSubviewToFront:btnSure.titleLabel];
    
    UIView *tap = [[UIView alloc] init];
    [self addSubview:tap];
    [tap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.title.mas_top);
    }];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [tap addGestureRecognizer:tap1];
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = self.bounds;
    }];
}

- (void)setViewType:(CustomVipSelectTableViewType)viewType{
    _viewType = viewType;
    switch (viewType) {
        case CustomVipSelectTableViewTypeBuyWholesale:
            self.title.text = @"VIP会员批发可享";
            break;
        case CustomVipSelectTableViewTypeTreturnoOnProfit:
            self.title.text = @"VIP会员返利";
            break;
            
        default:
            break;
    }
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
    if (self.viewType == CustomVipSelectTableViewTypeTreturnoOnProfit) {
        //返利
        static NSString *cellIdentifier = @"CustomVipTreturnoOnProfittTableViewCell";
        
        CustomVipTreturnoOnProfittTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[CustomVipTreturnoOnProfittTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        cell.rebateInfoModel = (RebateInfo *)self.arrDate[indexPath.row];
        return cell;
       
    } else {
        static NSString *cellIdentifier = @"CustomVipSelectTableViewCell";
        
        CustomVipSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[CustomVipSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.priceInfosModel = (PriceInfos *)self.arrDate[indexPath.row];

        
        return cell;
    }
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (void)touchAction{
    [self removeViewAnimate];
}
- (void)removeViewAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = CGRectMake(0, ScreenH, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
