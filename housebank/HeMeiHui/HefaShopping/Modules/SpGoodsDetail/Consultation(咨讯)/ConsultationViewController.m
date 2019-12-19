//
//  ConsultationViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ConsultationViewController.h"

@interface ConsultationViewController ()

@end

@implementation ConsultationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.customNavBar.hidden=NO;
    self.customNavBar.title=@"咨讯";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"商品详情-返回-icon"]];
//    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"forward2"]];
    [self.customNavBar wr_setBackgroundAlpha:0];
    UILabel *linelable=[[UILabel alloc]initWithFrame:CGRectMake(0, self.customNavBar.height+1, ScreenW, 1)];
    linelable.backgroundColor=HEXCOLOR(0XE5E5E5);
    [self.customNavBar addSubview:linelable];
    if (self.url==nil||[self.url isEqualToString:@""]) {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.center=self.view.center;
        imageView.bounds=CGRectMake(0, 0, 34, 40);
        imageView.image=[UIImage imageNamed:@"无资讯"];
        [self.view addSubview:imageView];
        UILabel *lable=[[UILabel alloc]init];
        lable.center=CGPointMake(imageView.centerX, imageView.centerY+40);
        lable.bounds=CGRectMake(0, 0, 85, 20);
        lable.text=@"没有相关资讯";
        lable.textColor=HEXCOLOR(0X999999);
        lable.font=PFR14Font;
        [self.view addSubview:lable];
        
    }
//    self.customNavBar.onClickRightButton=^(void) {
//        [weakSelf  topShareBtnClick];
//    };
//    self.customNavBar.titleLabelColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
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
