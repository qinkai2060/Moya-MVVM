//
//  WARUserProfileEditViewController.h
//  Pods
//
//  Created by huange on 2017/8/23.
//
//

#import "WARUserEditBaseViewController.h"

@interface WARUserProfileEditViewController : WARUserEditBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
