//
//  Target_MessageSetting.h
//  WARProfile
//
//  Created by huange on 2017/11/14.
//

#import <Foundation/Foundation.h>

@interface Target_MessageSetting : NSObject

- (UIViewController *)Action_WARMessageSettingViewController:(id)param;
- (UIViewController *)Action_WARCreatGroupViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARGroupMangerViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARProfileOtherViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARUserCenterViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARFaceSignatureViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARFaceSubEditViewController:(NSDictionary*)params;
- (void)Action_WARFavriteGenarlView:(NSDictionary*)params ;



- (UIViewController *)Action_WARFriendListViewController:(NSDictionary*)params;
- (void)Action_WARFriendListViewControllerLoadData:(NSDictionary *)params;
- (void)Action_WARFriendListViewControllerLoadDataWithLable:(NSDictionary *)params;


/** 地图个人主页日志列表 */
- (UIViewController *)Action_WARMapProfileMomentListVC:(NSDictionary*)params;

@end
