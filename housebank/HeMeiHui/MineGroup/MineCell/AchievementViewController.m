//
//  AchievementViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/5/5.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AchievementViewController.h"
#import "UIView+addGradientLayer.h"
@interface AchievementViewController ()

@end

@implementation AchievementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    _view1.alpha=0.6;
//    _view1.backgroundColor=HEXCOLOR(0X000000);
//    [self.view addSubview:_view1];
  
    [self creatSubView];
    // Do any additional setup after loading the view.
}
-(void)creatSubView
{
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 170)];
    subView.center=self.view.center;
    subView.backgroundColor= [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    subView.layer.masksToBounds=YES;
    subView.layer.cornerRadius=10;
    [self.view  addSubview:subView];
    
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(0,27, subView.width, 20)];
    hotLab.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    hotLab.textAlignment=NSTextAlignmentCenter;
    hotLab.textColor=HEXCOLOR(0x333333);
    hotLab.text=@"本月业绩";
    [subView addSubview:hotLab];
    
    _rmLab = [[UILabel alloc] initWithFrame:CGRectMake(0,hotLab.buttomY+10, subView.width, 20)];
    _rmLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    _rmLab.textAlignment=NSTextAlignmentCenter;
    _rmLab.textColor=HEXCOLOR(0x333333);
    _rmLab.text=@"RM:";
    [subView addSubview:_rmLab];
    
    _shopLab = [[UILabel alloc] initWithFrame:CGRectMake(0,_rmLab.buttomY+5, subView.width, 20)];
    _shopLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    _shopLab.textAlignment=NSTextAlignmentCenter;
    _shopLab.textColor=HEXCOLOR(0x333333);
    _shopLab.text=@"商城:";
    [subView addSubview:_shopLab];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, subView.height-45, subView.width, 45);
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    [button addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [button addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:button];
}
-(void)setDatavale:(NSString *)rmvale shopLab:(NSString *)shopLab
{
    _rmLab.text=[NSString stringWithFormat:@"RM:%@",rmvale];
    _shopLab.text=[NSString stringWithFormat:@"商城:%@",shopLab];
}
-(void)removeClick
{
    [self.view removeFromSuperview];
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
