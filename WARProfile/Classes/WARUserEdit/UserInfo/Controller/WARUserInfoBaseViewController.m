//
//  WARUserInfoBaseViewController.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/30.
//

#import "WARUserInfoBaseViewController.h"
#import "UIImage+WARBundleImage.h"

@interface WARUserInfoBaseViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation WARUserInfoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLeftButtonItem];
    [self createRightButtonItem];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.shadowImage = nil;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
}

- (void)createLeftButtonItem {
    //back button item
    self.navigationItem.hidesBackButton = YES;
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backButton setImage:[UIImage war_imageName:@"app_back" curClass:[self class] curBundle:@"WARControl.bundle"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
}


- (void)createRightButtonItem {
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];

    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    [self.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backAction {
    if (self.valueChanged) {
        [WARAlertView showWithTitle:nil
                            Message:WARLocalizedString(@"保存本次编辑？")
                        cancelTitle:WARLocalizedString(@"不保存")
                        actionTitle:WARLocalizedString(@"保存")
                      cancelHandler:^(LGAlertView * _Nonnull alertView) {
                          [self.navigationController popViewControllerAnimated:YES];
                      } actionHandler:^(LGAlertView * _Nonnull alertView) {
                          [self rightButtonAction];
                      }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonAction {
    
}

#pragma mark - setter method
- (void)setRightButtonText:(NSString *)rightButtonText {
    if (!self.rightButton) {
        [self createRightButtonItem];
    }
    
    _rightButtonText = rightButtonText;
    [self.rightButton setTitle:_rightButtonText forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
