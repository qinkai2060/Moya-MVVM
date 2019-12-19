//
//  AboutUsView.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "AboutUsView.h"
#import "AboutUsTableViewCell.h"

@interface AboutUsView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutUsView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    [self addSubview:self.tableView];
}
- (void)setArrDateSoure:(NSMutableArray *)arrDateSoure{
    _arrDateSoure = arrDateSoure;
    [self.tableView reloadData];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:(UITableViewStyleGrouped)];
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
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 125;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 125)];
    header.backgroundColor = HEXCOLOR(0xF5F5F5);
    
    UIImageView *imglogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hflogo"]];
    imglogo.backgroundColor = [UIColor redColor];
    [header addSubview:imglogo];
    [imglogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header);
        make.top.equalTo(header).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *version = [[UILabel alloc] init];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    version.text = [NSString stringWithFormat:@"版本 v%@", appVersion];
    version.textColor = HEXCOLOR(0x999999);
    version.font = PFR12Font;
    [header addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header);
        make.top.equalTo(imglogo.mas_bottom).offset(10);
    }];
    return header;
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
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.arrDateSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        switch (indexPath.row) {
            case 0:
            {
                //关于合发
                self.clickBlock(AboutUsViewtTypeAboutHF);

            }
                break;
            case 1:
            {
                //意见箱
                self.clickBlock(AboutUsViewtTypeIdea);

            }
                break;
            case 2:
            {
                //boss邮箱
                self.clickBlock(AboutUsViewtTypeBossEmail);

            }
                break;
            case 3:
            {
                //联系我们
                self.clickBlock(AboutUsViewtTypeCallUs);
            }
                break;
                
            default:
                break;
        }
    }
}


@end
