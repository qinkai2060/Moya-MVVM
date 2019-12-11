//
//  WARUserInfoCreateNewTagViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import <UIKit/UIKit.h>
#import "WARUserInfoBaseViewController.h"

typedef NS_ENUM(NSInteger,UserInfoCreateNewTagViewControllerType) {
    UserInfoCreateNewTagViewControllerTypeOfHometown = 0,
    UserInfoCreateNewTagViewControllerTypeOfIndustry,
    UserInfoCreateNewTagViewControllerTypeOfWork,
    UserInfoCreateNewTagViewControllerTypeOfCompany,
    UserInfoCreateNewTagViewControllerTypeOfFood,
    UserInfoCreateNewTagViewControllerTypeOfSports,
    UserInfoCreateNewTagViewControllerTypeOfTravel,
    UserInfoCreateNewTagViewControllerTypeOfOther,
};


typedef void(^WARUserInfoCreateNewTagAddBlock)(NSString *tagStr);

@interface WARUserInfoCreateNewTagViewController : WARUserInfoBaseViewController

@property (nonatomic, copy)WARUserInfoCreateNewTagAddBlock addBlock;

- (instancetype)initWithType:(UserInfoCreateNewTagViewControllerType)type;

@end
