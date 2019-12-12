//
//  WARPhotoBaseViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoBaseViewController.h"
#import "WARGroupModel.h"
#import "WARBaseMacros.h"
@interface WARPhotoBaseViewController ()
@property(nonatomic,strong)WARGroupModel *model;

@end

@implementation WARPhotoBaseViewController
- (instancetype)initWithModel:(WARGroupModel*)model{
    if (self =[super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//   [self.view addSubview:self.customBar];
}


- (WARNavgationCutsomBar *)customBar{
    if (!_customBar) {
        WS(weakself);
        _customBar = [[WARNavgationCutsomBar alloc] initWithTile:@"" rightTitle:@"" alpha:0 backgroundColor:[UIColor whiteColor] rightHandler:^{
            [weakself rightAction];
        } leftHandler:^{
            [weakself leftAtction];
        }];
        CGFloat height =    WAR_IS_IPHONE_X ? 84:64;
       _customBar.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _customBar;
}
- (void)rightAction{
    
}
- (void)leftAtction{
       [self.navigationController popViewControllerAnimated:YES];
}
@end
