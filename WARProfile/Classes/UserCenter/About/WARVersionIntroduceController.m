//
//  WARVersionIntroduceController.m
//  Pods
//
//  Created by huange on 2017/8/16.
//
//

#import "WARVersionIntroduceController.h"

@interface WARVersionIntroduceController ()

@end

@implementation WARVersionIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = WARLocalizedString(@"版本介绍");
    
    NSString *icon = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *iconImage = [UIImage imageNamed:icon];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.layer.cornerRadius = 4;
    iconImageView.clipsToBounds = YES;
    [self.view addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(120);
        make.width.mas_equalTo(iconImage.size.width);
        make.height.mas_equalTo(iconImage.size.height);
    }];
    
    //version
    NSString *shortversion =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSString *tempString = WARLocalizedString(@"当前版本 ");
    NSString *versionString = [NSString stringWithFormat:@"V%@.%@",shortversion,version];
    
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = DisabledTextColor;
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.text = [NSString stringWithFormat:@"%@%@",tempString,versionString];
    [self.view addSubview:descriptionLabel];
    
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).with.offset(15);
        make.leading.equalTo(self.view.mas_leading).with.offset(15);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-15);
        make.height.mas_equalTo(22);
    }];
}


@end
