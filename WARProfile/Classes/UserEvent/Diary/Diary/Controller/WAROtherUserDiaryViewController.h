//
//  WAROtherUserDiaryViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/23.
//

#import "WARBaseUserDiaryViewController.h"

@interface WAROtherUserDiaryViewController : WARBaseUserDiaryViewController

- (instancetype)initWithFriendId:(NSString *)friendId;

@property (nonatomic, strong) UITableView *tableView;

@end
