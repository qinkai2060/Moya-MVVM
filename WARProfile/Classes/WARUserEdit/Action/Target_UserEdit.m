//
//  Target_UserEdit.m
//  Pods
//
//  Created by huange on 2017/9/4.
//
//

#import "Target_UserEdit.h"
#import "WARUserSettingNewViewController.h"
#import "WARUserProfileEditViewController.h"
#import "WARMoveGroupViewController.h"
#import "WARFaceManagerViewController.h"
#import "WARContactsCategoryViewController.h"
#import "WARUserSettingBackgroundViewController.h"

@implementation Target_UserEdit

- (UIViewController *)Action_WARUserSettingNewViewController:(NSDictionary*)params {
    WARUserSettingNewViewController *vc = [[WARUserSettingNewViewController alloc] init];
    vc.guyId = params[@"guyId"];
    return vc;
}

- (UIViewController *)Action_WARUserEditViewController:(id)param {
    WARUserProfileEditViewController *userEditerVC = [[WARUserProfileEditViewController alloc] init];
    return userEditerVC;
}

- (UIViewController *)Action_contactsCategoryManagementController:(id)param{
    NSString *string = [param objectForKey:@"categoryId"];
    NSString *accountId = [param objectForKey:@"accountId"];
    WARMoveGroupViewController *vc = [[WARMoveGroupViewController alloc]init];
    vc.currentCategoryId = string;
    vc.accountId = accountId;
    return vc;
}



- (UIViewController *)Action_WARUserFaceManagerController:(id)param{
    WARFaceManagerViewController *vc = [[WARFaceManagerViewController alloc]init];
    vc.curFaceId = [param objectForKey:@"curFaceId"];
    return vc;
}


- (UIViewController *)Action_WARUserContactsCategoryController:(id)param{
    NSArray *faces = [param objectForKey:@"faces"];
    WARContactsCategoryViewController *vc = [[WARContactsCategoryViewController alloc]init];
    vc.faces = faces;
    return vc;
}

- (UIViewController *)Action_WARUserSettingBackgroundViewController:(id)param{
    NSString *groupId = [param objectForKey:@"groupId"];
    WARUserSettingBackgroundViewController *vc = [[WARUserSettingBackgroundViewController alloc]init];
    vc.groupId = groupId;
    return vc;
}

@end
