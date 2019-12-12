//
//  WARJournalListViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARBaseUserDiaryViewController.h"

@interface WARJournalListViewController : WARBaseUserDiaryViewController
@property (nonatomic, strong) UITableView *tableView;
- (void)loadDataRefresh:(BOOL)refresh;
@end
