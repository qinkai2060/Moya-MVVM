//
//  WARProfileOtherViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/17.
//

#import <UIKit/UIKit.h>
#import "WARProfileUserModel.h"
#import "WARNavgationBar.h"
@interface WARProfileOtherViewController : UIViewController
//是否应该刷新
@property(nonatomic,assign)BOOL shouldRefresh;
//是否在刷新
@property(nonatomic,assign)BOOL isRefreshing;
//偏移量
@property(nonatomic,assign)NSInteger lastContentOffY;
/**
 参数
 */
@property (nonatomic, strong) WARProfileUserModel *profileUsermodel;

@property (strong, nonatomic)  WARNavgationBar *userPageNavBar;
- (instancetype)initWithGuyID:(NSString *)guyID friendWay:(NSString *)friendWay;
@end
