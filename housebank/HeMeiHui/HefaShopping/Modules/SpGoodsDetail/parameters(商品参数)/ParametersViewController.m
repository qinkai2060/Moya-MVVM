//
//  ParametersViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ParametersViewController.h"
#import "ParametersTailesCell.h"
#import"UIView+addGradientLayer.h"

#define NowScreenH ScreenH-250
@interface ParametersViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ParametersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    view.alpha=0.6;
    view.backgroundColor=HEXCOLOR(0X000000);
    [self.view addSubview:view];
    [self creatSubView];
    // Do any additional setup after loading the view.
}
-(void)creatSubView
{
    __weak typeof(self)weakSelf = self;
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 250, ScreenW, NowScreenH)];
    subView.backgroundColor=[UIColor whiteColor];
    subView.alpha=1.0;
    [self.view addSubview:subView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, NowScreenH-TabBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView=[self  creatTableViewHeader];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subView addSubview:self.tableView];
    
    UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
    buttton.frame = CGRectMake(0, NowScreenH-TabBarHeight, ScreenW, 50);
    [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttton setTitle:@"确定" forState:UIControlStateNormal];
    [buttton setTitleColor:HEXCOLOR(0XFFFFFF) forState:UIControlStateNormal];
    //     buttton.backgroundColor=[UIColor redColor];
    [buttton addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [subView addSubview:buttton];
    
    
}
-(UIView *)creatTableViewHeader
{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    
    /* title*/
    UILabel * Label=[[UILabel alloc]init];
    Label.center=_headerView.center;
    Label.bounds=CGRectMake(0, 0, 100, 20);
    Label.font = PFR16Font;
    Label.textColor=HEXCOLOR(0x333333);
    Label.textAlignment=NSTextAlignmentCenter;
    Label.text=@"产品参数";
    [_headerView addSubview:Label];
    
    return _headerView;
}
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParametersTailesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
    if (cell == nil) {
        cell = [[ParametersTailesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
