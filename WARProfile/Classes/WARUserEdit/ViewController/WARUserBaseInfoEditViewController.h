//
//  WARUserBaseInfoEditViewController.h
//  Pods
//
//  Created by huange on 2017/8/24.
//
//

#import "WARUserEditBaseViewController.h"

typedef NS_ENUM(NSInteger, UserInfoType) {
    UserInfoNickNameType,
    UserInfoSexType,
    UserInfoBirthdayType,
};

@interface WARUserBaseInfoEditViewController : WARUserEditBaseViewController

@property (nonatomic, assign) UserInfoType userInfoType;
@property (nonatomic, strong) UITableView *tableView;

@end
