//
//  MyIdcardViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/26.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "MyIdcardViewController.h"
#import "MyIdcardView.h"
#import "MyIdCardModel.h"
#define FitiPhone6Scale(x) ((x) * ScreenW / 375.0f)

@interface MyIdcardViewController ()
@property (nonatomic, strong) MyIdcardView *myidcardView;
@end

@implementation MyIdcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}
- (void)createView{
    self.title = @"我的名片";
    
    [self.view addSubview:self.myidcardView];

    
    [self requestqueryBussinessCard:NO];
    
    
}
- (MyIdcardView *)myidcardView{
    if (!_myidcardView) {
        _myidcardView = [[MyIdcardView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88)];
        __weak typeof(self) weakself = self;
        _myidcardView.refrenshBlock = ^{
            [weakself refrenshBlockAction];
        };
    }
    return _myidcardView;
}
/**
  刷新方法
 */
- (void)refrenshBlockAction{
    [self requestqueryBussinessCard:YES];
}


- (void)requestqueryBussinessCard:(BOOL)refrensh{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
   
    NSString *logoPath = [self.imagePath get_sharImage];
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"contents":[NSString stringWithFormat:@"%@/html/register.html?tuiId=%@&flag=1",fyMainHomeUrl, USERDEFAULT(@"uid")],
                          @"logoPath":logoPath
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/member/queryBussinessCard2"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if (refrensh) {
                [self showSVProgressHUDSuccessWithStatus:@"刷新信息成功!"];
            } else{
                [SVProgressHUD dismiss];
            }
//            self.myidcardView.strHeader = logoPath;
          
            MyIdCardModel *idCardModel = [MyIdCardModel modelWithJSON: [[dic objectForKey:@"data"] objectForKey:@"data"]];

            self.myidcardView.idCardModel = idCardModel;
            
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
       
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
@end
