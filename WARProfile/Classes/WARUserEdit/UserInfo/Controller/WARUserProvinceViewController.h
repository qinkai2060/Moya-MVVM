//
//  WARUserProvinceViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import <UIKit/UIKit.h>

#import "WARUserInfoBaseViewController.h"

@class WARUserProvinceModel;
@class WARUserCityModel;

typedef void(^WARUserHometownBlock)(WARUserProvinceModel *provinceM,WARUserCityModel *cityM);


@interface WARUserProvinceViewController : WARUserInfoBaseViewController

@property (nonatomic, copy)WARUserHometownBlock userHometownBlock;

@end
