//
//  AboutHFViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "AboutHFViewController.h"

@interface AboutHFViewController ()

@end

@implementation AboutHFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于合发";
    [self createView];
}
- (void)createView{
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textview = [[UITextView alloc] init];
    textview.textColor = HEXCOLOR(0x333333);
    textview.font = PFR14Font;
    textview.editable = NO;
    textview.text = @"    合发（上海）网络技术有限公司成立于2011年，是一家以“互联网+房地产+酒店+商城+大数据”为主营业务的新零售闭环生态型电商平台。公司总部运营中心坐落于上海浦东新区临港新城，美丽的滴水湖畔。研发中心位于市北高新科技园，目前业务遍布全国300多个城市。\n    公司自成立以来，一直积极响应国家号召，以十八大提出的“创新，协调，绿色，开发，共享”五大发展理念为指导，在借鉴美国先进成功的RM和AIRBNB的经营理念的基础上，结合中国国情改造升级。以房产去库存为己任，以消费拉动创业为基础，以移动互联网，区块链，云计算，大数据，物联网等为工具，全力打造一个无国界，跨行业，共享式的产业化电商平台。平台以“筑财富通路，让伙伴幸福”为使命，开启了“流通创造价值，消费产生利润”的新商业模式，为创业，就业，扶贫提供了全方位一体化解决方案。在帮助传统企业插上互联网翅膀的同时，更有效地助力企业产品走向全国乃至全世界。通过互联网创新模式让大众创业实现低门槛加入，更好帮助老百姓创业，以创业带动就业，积累了大量可行的经验和基础。";
    [self.view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-15);
    }];
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
