//
//  WARUserInfoSearchViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import <UIKit/UIKit.h>
#import "WARUserInfoBaseViewController.h"
#import "WARFaceMaskModel.h"
#import "WARProfileUserModel.h"


typedef NS_ENUM(NSInteger,UserInfoSearchType) {
    UserInfoSearchTypeOfSchool = 0,
    UserInfoSearchTypeOfBook,
    UserInfoSearchTypeOfMovie,
    UserInfoSearchTypeOfMusic,
    UserInfoSearchTypeOfGame,
    UserInfoSearchTypeOfCompany,
    UserInfoSearchTypeOfRemark,
    UserInfoSearchTypeOfTag,
    UserSettingRemark
};



typedef void(^SearchBlock)(NSString *resultsStr);
typedef void(^RemarkBlock)(NSString *remarkStr);

@interface WARUserInfoSearchViewController : WARUserInfoBaseViewController

@property (nonatomic, strong) WARFaceMaskModel *currentFaceModel;
@property (nonatomic, copy)SearchBlock searchBlock;
@property (nonatomic, copy)RemarkBlock remarkBlock;

@property (nonatomic, strong) WARProfileUserSettingModel *settingModel;

- (instancetype)initWithType:(UserInfoSearchType)type;

@end
