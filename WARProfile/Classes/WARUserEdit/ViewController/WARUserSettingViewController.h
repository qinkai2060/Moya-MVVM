//
//  WARUserSettingViewController.h
//  Pods
//
//  Created by huange on 2017/9/5.
//
//

#import "WARUserEditBaseViewController.h"
#import "WARConst.h"
#import "WARProfileUserModel.h"

@interface WARUserSettingViewController : WARUserEditBaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WARProfileUserModel *model;

- (instancetype)initWithAccount:(NSString *)accountID type:(UMainControllerPersonType)type;

@end
