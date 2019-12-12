//
//  WARUserSettingBackgroundViewController.h
//  WARProfile
//
//  Created by Hao on 2018/6/20.
//

#import "WARBaseViewController.h"
#import "WARProfileUserModel.h"

@interface WARUserSettingBackgroundViewController : WARBaseViewController

@property (nonatomic, strong) WARProfileUserModel *userModel;

@property (nonatomic, copy) NSString *groupId;

@end
