//
//  WARUserEditBaseViewController.m
//  Pods
//
//  Created by huange on 2017/8/23.
//
//

#import "WARUserEditBaseViewController.h"
#import "WARUIHelper.h"
#import "UIImage+Color.h"
#import "WARAlertView.h"

@interface WARUserEditBaseViewController ()

@end

@implementation WARUserEditBaseViewController

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

@end
