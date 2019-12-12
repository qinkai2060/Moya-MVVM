//
//  WARFaceSubEditViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/23.
//

#import <UIKit/UIKit.h>
#import "WARFaceBaseViewController.h"
#import "WARGroupHomeModel.h"

@class WARFaceMaskModel;

typedef NS_ENUM(NSInteger, FaceSubEditUserInfoType) {
    FaceSubEditUserInfoNickNameType,
    FaceSubEditUserInfoSexType,
    FaceSubEditUserInfoBirthdayType,
    FaceSubEditGroupNameType,
    FaceSubEditGroupNickNameType
};

typedef void(^SubEduitBlock)(NSString *text);

@interface WARFaceSubEditViewController : WARFaceBaseViewController
@property (nonatomic, strong) WARFaceMaskModel *currentFaceModel;

@property (nonatomic, copy) SubEduitBlock editBlock;
@property (nonatomic, assign) FaceSubEditUserInfoType userInfoType;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithGroupHomeModel:(WARGroupHomeModel *)groupHomeModel title:(NSString *)title;

@end
