//
//  SpGoodParticularsViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpGoodParticularsViewController.h"
#import "DCLIRLButton.h"
@interface SpGoodParticularsViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@end

@implementation SpGoodParticularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.dc_width, self.view.dc_height)];
    _webView.navigationDelegate=self;
    _webView.scrollView.bounces = NO;

        
        _webView.frame = CGRectMake(0, 0, self.view.dc_width, ScreenH -KTopHeight-TabBarHeight);
 
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_webView];
    [self resetDataView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}


- (NSString *)reSizeImageWithHTMLHadHead:(NSString *)html {
    //    CGFloat with=[UIScreen mainScreen].bounds.size.width;
     ManagerTools *manageTools =  [ManagerTools ManagerTools];
    return [html stringByReplacingOccurrencesOfString:@"src=\"" withString:[NSString stringWithFormat:@"src=\"%@", manageTools.appInfoModel.imageServerUrl]];
    
}
-(void)resetDataView
{
    NSString *str=self.detailModel.data.product.productDescription;
//     NSString *str=@"<img src=\"/user/community/1544863103/ncddxs93tib23y72.jpg!PD750\" style=\"width:100%\">";
    NSString *htmlStr= [self reSizeImageWithHTMLHadHead:str];
    if (str!=nil&&![str isEqualToString:@""]) {
           [_webView loadHTMLString:htmlStr baseURL:nil];
    }

}
//#pragma mark - 视图滚动
//- (void)setUpViewScroller{
//    WEAKSELF
//    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.spGoodBaseVC.changeTitleBlock ? : weakSelf.spGoodBaseVC.changeTitleBlock(NO);
//            weakSelf.spGoodBaseVC.scrollerView.contentOffset = CGPointMake(0, 0);
//        } completion:^(BOOL finished) {
//            [weakSelf.tableView.mj_header endRefreshing];
//        }];
//
//
//        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.assembleGoodbaseVC.changeTitleBlock ? : weakSelf.assembleGoodbaseVC.changeTitleBlock(NO);
//            weakSelf.assembleGoodbaseVC.scrollerView.contentOffset = CGPointMake(0, 0);
//        } completion:^(BOOL finished) {
//            [weakSelf.tableView.mj_header endRefreshing];
//        }];
//
//    }];
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"completionHandler:nil];
    
//    //修改字体颜色  #9098b8
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'"completionHandler:nil];
    
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
