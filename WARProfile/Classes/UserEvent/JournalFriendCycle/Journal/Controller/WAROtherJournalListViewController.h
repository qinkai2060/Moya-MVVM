//
//  WAROtherJournalListViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARBaseUserDiaryViewController.h"

@interface WAROtherJournalListViewController : WARBaseUserDiaryViewController

- (instancetype)initWithFriendId:(NSString *)friendId;

@property (nonatomic, strong) UITableView *tableView;

@end
