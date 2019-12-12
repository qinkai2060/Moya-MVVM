//
//  Target_UserEdit.h
//  Pods
//
//  Created by huange on 2017/9/4.
//
//

#import <Foundation/Foundation.h>

@interface Target_UserEdit : NSObject

- (UIViewController *)Action_WARUserSettingNewViewController:(NSDictionary*)params;
- (UIViewController *)Action_WARUserEditViewController:(id)param;

// 移动联系人
- (UIViewController *)Action_contactsCategoryManagementController:(id)param;

// 面具管理
- (UIViewController *)Action_WARUserFaceManagerController:(id)param;
// 分组管理
- (UIViewController *)Action_WARUserContactsCategoryController:(id)param;

// 聊天背景
- (UIViewController *)Action_WARUserSettingBackgroundViewController:(id)param;

@end
