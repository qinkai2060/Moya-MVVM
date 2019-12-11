//
//  WARUSerCenterProfileCell.h
//  Pods
//
//  Created by 秦恺 on 2018/1/29.
//

#import <UIKit/UIKit.h>
#import "WARJournalListViewController.h"
#import "WARUserRepositoryViewController.h"
#import "WARUserOrderViewController.h"
#import "WARUserOtherViewController.h"
#import "WARCPageContentView.h"
#import "WARUserEventMainViewController.h"
@class TZAssetModel;
@class WARUSerCenterProfileCell;
@protocol WARUSerCenterProfileDelegete <NSObject>
- (void)USerCenterProfileCell:(WARUSerCenterProfileCell*)cell scrollindex:(NSInteger)pageContentViewindex progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex;
-(void)dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:(WARUSerCenterProfileCell *)cell;
@end
@interface WARUSerCenterProfileCell : UITableViewCell<WARCPageContentViewDelegare>
@property (nonatomic,retain) NSMutableArray *childViewControllersArray;

@property (nonatomic,weak) id <WARUSerCenterProfileDelegete> delegate;

//cell注册
+ (void)regisCellForTableView:(UITableView *)tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isOtherEnterHome;
//是不是自己
@property (nonatomic, assign) BOOL isMine;
//子控制器是否可以滑动  YES可以滑动
@property (nonatomic, assign) BOOL canScroll;
//外部segment点击更改selectIndex,切换页面
@property (assign, nonatomic) NSInteger selectIndex;
//@property(nonatomic,weak)id<ContentViewCellDelegate> delegate;
/**guyid*/
@property (nonatomic,copy) NSString *guyID;
//创建pageViewController
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier atType:(BOOL)isMine atGuyId:(NSString*)guyID; 
- (void)setPageView;
- (void)customPageView ;
-(void)dl_refresh;
- (void)dragViewPoint:(CGPoint)point selectIndex:(NSInteger)selectIndex data:(TZAssetModel*)model;
- (void)dragViewPointChange:(CGPoint)point selectIndex:(NSInteger)selectIndex data:(TZAssetModel*)model;
- (void)outDragViewPoint;
@end
