//
//  WARFollowViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARBaseViewController.h"

typedef void (^DealWithLoadResultNoMoreDataBlock)(BOOL noMoreData);

@interface WARFollowViewController : WARBaseViewController

@property (nonatomic, copy) DealWithLoadResultNoMoreDataBlock dealWithLoadResultNoMoreDataBlock;
 
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) float contentOffsetY;
@property (nonatomic, assign) float contentOffsetBottomY;
@property (nonatomic, assign) float contentOffsetUpY;

- (void)loadDataRefresh:(BOOL)refresh ;
- (void)dealWithLoadResultNoMoreData:(BOOL)noMoreData;

@end
