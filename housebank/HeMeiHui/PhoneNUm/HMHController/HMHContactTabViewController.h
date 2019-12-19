//
//  HMHContactTabViewController.h
//  housebank
//
//  Created by 任为 on 2017/9/18.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPhoneBookViewController.h"
#import "HMHContactTabViewController.h"


@interface HMHContactTabViewController : UIViewController
@property (nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,strong)HMHPhoneBookViewController *phoneVC;
@property(nonatomic,weak)UIButton  *contactListButton;

- (void)butonCilck:(UIButton*)selectedButton;

@end
