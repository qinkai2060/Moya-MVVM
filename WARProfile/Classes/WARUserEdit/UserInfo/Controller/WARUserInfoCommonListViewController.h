//
//  WARUserInfoCommonListViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import <UIKit/UIKit.h>
#import "WARUserInfoBaseViewController.h"

@class WARUserCityModel;

typedef NS_ENUM(NSInteger,UserInfoCommonListViewControllerType) {
    UserInfoCommonListViewControllerTypeOfHometown = 0,
    UserInfoCommonListViewControllerTypeOfIndustry,
    UserInfoCommonListViewControllerTypeOfWork,
    UserInfoCommonListViewControllerTypeOfFood,
    UserInfoCommonListViewControllerTypeOfSports,
    UserInfoCommonListViewControllerTypeOfTravel,
};


typedef NS_ENUM(NSInteger,UserInfoCommonListSelectType) {
    UserInfoCommonListSelectTypeOfSignal = 0,
    UserInfoCommonListSelectTypeOfMulti,
};


typedef void(^WARUserInfoDidSelectCityBlock)(WARUserCityModel *model);
typedef void(^WARUserInfoDidSelectItemBlock)(NSString *itemStr);
typedef void(^WARUserInfoDidSureBlock)(NSArray *selectArr);


@interface WARUserInfoCommonListViewController : WARUserInfoBaseViewController

@property (nonatomic, copy)WARUserInfoDidSelectCityBlock didSelectCityBlock;
@property (nonatomic, copy)WARUserInfoDidSelectItemBlock didSelectItemBlock;
@property (nonatomic, copy)WARUserInfoDidSureBlock didSureBlock;


@property (nonatomic, copy)NSArray *dataArr;
@property (nonatomic, strong)NSArray *lastSelectArray;

- (instancetype)initWithType:(UserInfoCommonListViewControllerType)type title:(NSString *)title selectType:(UserInfoCommonListSelectType)selectType;

@end
