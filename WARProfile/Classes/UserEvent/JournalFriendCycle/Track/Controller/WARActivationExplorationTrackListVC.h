//
//  WARFriendViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARBaseViewController.h"

@interface WARActivationExplorationTrackListVC : WARBaseViewController

/**
 初始化控制器
 @param accountId 用户id
 @param lat 纬度
 @param lon 经度
 @param pushController push控制器
 @return return value description
 */
- (instancetype)initWithAccountId:(NSString *)accountId
                              lat:(NSString *)lat
                              lon:(NSString *)lon
              pushController:(UIViewController *)pushController;

/** 动态列表展示 */
@property (nonatomic, strong) UITableView *tableView;
/** tableView是否可以滚动 */
@property (nonatomic, assign) BOOL canScroll;
/** tableView 的 contentOffsetY */
@property (nonatomic, assign) float contentOffsetY;
/** tableView 的 contentOffsetBottomY */
@property (nonatomic, assign) float contentOffsetBottomY;
/** tableView 的 contentOffsetUpY */
@property (nonatomic, assign) float contentOffsetUpY;

@end
