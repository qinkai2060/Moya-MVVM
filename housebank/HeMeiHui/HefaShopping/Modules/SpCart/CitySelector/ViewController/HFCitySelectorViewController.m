//
//  HFCitySelectorViewController.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCitySelectorViewController.h"
#import "HFCitySelectorView.h"
#import "HFCitySelectorViewModel.h"
@interface HFCitySelectorViewController ()
@property (nonatomic,strong)HFCitySelectorView *citySelectoryView;
@property (nonatomic,strong)HFCitySelectorViewModel *viewModel;
@end

@implementation HFCitySelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.citySelectoryView];
    @weakify(self);
    [self.viewModel.closeSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (HFCitySelectorView *)citySelectoryView {
    if (!_citySelectoryView) {
        _citySelectoryView = [[HFCitySelectorView alloc] initWithFrame:CGRectMake(0, 115, ScreenW, ScreenH-115) WithViewModel:self.viewModel];
    }
    return _citySelectoryView;
}
- (HFCitySelectorViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFCitySelectorViewModel alloc] init];
    }
    return _viewModel;
}
@end
