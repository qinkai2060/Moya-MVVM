//
//  Target_MessageSetting.m
//  WARProfile
//
//  Created by huange on 2017/11/14.
//

#import "Target_MessageSetting.h"
#import "WARMessageSettingViewController.h"
#import "WARCreatGroupViewController.h"
#import "WARGroupMangerViewController.h"
#import "WARProfileOtherViewController.h"
#import "WARUserCenterViewController.h"
#import "WARFaceSignatureViewController.h"
#import "WARFaceSubEditViewController.h"
#import "WARFavriteShowViewController.h"
#import "WARFriendListViewController.h"
#import "WARMapProfileMomentListVC.h"

typedef void (^WARCreatGroupBlock)();
typedef void (^WARGroupDesBlock)(NSString *groupDes);

@implementation Target_MessageSetting

- (UIViewController *)Action_WARMessageSettingViewController:(id)param {
    WARMessageSettingViewController *userMessageSettingVC = [[WARMessageSettingViewController alloc] init];
    return userMessageSettingVC;
}
- (UIViewController *)Action_WARCreatGroupViewController:(NSDictionary*)params {
    WARCreatGroupViewController *CreatGroupVC = [[WARCreatGroupViewController alloc] init];
    WARCreatGroupBlock callback = params[@"callback"];
    CreatGroupVC.callback = ^{
        callback();
    };
    return CreatGroupVC;
}
- (UIViewController *)Action_WARProfileOtherViewController:(NSDictionary*)params {
    NSString *guyID = params[@"accountId"];
    NSString *friendWay = params[@"friendWay"];
    WARProfileOtherViewController *otherVC = [[WARProfileOtherViewController alloc] initWithGuyID:guyID friendWay:friendWay];
    return otherVC;
}
- (UIViewController *)Action_WARUserCenterViewController:(NSDictionary*)params {
    WARUserCenterViewController *vc = [[WARUserCenterViewController alloc] init];
    
    vc.isOtherfromWindow = YES;
    return vc;
    
}

- (UIViewController *)Action_WARFaceSignatureViewController:(NSDictionary*)params {
    id model = params[@"model"];
    NSString *title = params[@"title"];
    WARFaceSignatureViewController *vc = [[WARFaceSignatureViewController alloc] initWithGroupHomeModel:model title:title];
    WARGroupDesBlock callback = params[@"callback"];
    [vc setGroupDesBlock:^(NSString *groupDes) {
        if (callback) {
            callback(groupDes);
        }
    }];
    return vc;
}

- (UIViewController *)Action_WARFaceSubEditViewController:(NSDictionary*)params {
    id model = params[@"model"];
    NSString *title = params[@"title"];
    WARFaceSubEditViewController *vc = [[WARFaceSubEditViewController alloc] initWithGroupHomeModel:model title:title];
    WARGroupDesBlock callback = params[@"callback"];
    [vc setEditBlock:^(NSString *text) {
        if (callback) {
            callback(text);
        }
    }];
    return vc;
}
- (void)Action_WARFavriteGenarlView:(NSDictionary*)params {
    UIViewController *vc = params[@"currentVC"];
    NSString *linkURL = params[@"linkURL"];
    
    WARFavriteShowViewController *showvc = [[WARFavriteShowViewController alloc] initWithViewController:vc];
    showvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    showvc.modalPresentationStyle = UIModalPresentationCustom;
    [vc presentViewController:showvc animated:NO completion:nil]; 

}

- (UIViewController *)Action_WARFriendListViewController:(NSDictionary*)params {
    UIViewController *pushController = params[@"pushController"];
    NSString *maskId = [NSString stringWithFormat:@"%@",params[@"maskId"]];
    NSString *from = [NSString stringWithFormat:@"%@",params[@"from"]];
    NSString *label = [NSString stringWithFormat:@"%@",params[@"label"]];
    NSArray <NSString *>*sysLabel = params[@"sysLabel"];
    
    WARFriendListViewController *controller = [[WARFriendListViewController alloc]initWithType:@"FOLLOW" maskId:maskId from:from label:label sysLabel:sysLabel pushController:pushController];
    controller.maskIdListsBlock = params[@"callBack"];
    
    return controller;
}

- (void)Action_WARFriendListViewControllerLoadData:(NSDictionary *)params {
    WARFriendListViewController *controller = (WARFriendListViewController *)params[@"controller"];
    [controller loadDataWithCategory:params[@"category"] isFollow:[params[@"isFollow"] boolValue]]; 
}


- (void)Action_WARFriendListViewControllerLoadDataWithLable:(NSDictionary *)params {
    WARFriendListViewController *controller = (WARFriendListViewController *)params[@"controller"];
    [controller loadDataWithLable:params[@"lable"]];
}

- (UIViewController *)Action_WARMapProfileMomentListVC:(NSDictionary*)params {
    NSString *accountId = params[@"accountId"];
    NSString *categoryLabel = params[@"categoryLabel"];
    NSString *lat = params[@"lat"];
    NSString *lon = params[@"lon"];
    NSString *momentId = params[@"momentId"];
    NSString *zoom = params[@"zoom"];
    NSString *pushController = params[@"pushController"];
    WARMapProfileMomentListVC *controller = [[WARMapProfileMomentListVC alloc]initWithAccountId:accountId categoryLabel:categoryLabel lat:lat lon:lon momentId:momentId zoom:zoom pushController:pushController];
    return controller;
}

@end
