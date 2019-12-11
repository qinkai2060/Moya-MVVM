//
//  WARUserEditBaseViewController.h
//  Pods
//
//  Created by huange on 2017/8/23.
//
//

#import <UIKit/UIKit.h>
#import "WARBaseShadowController.h"

#import "ReactiveObjC.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARConst.h"
#import "WARUserEditDataManager.h"
#import "WARProgressHUD.h"
#import "NSDate+WARCategory.h"

#define PlaceHolderColor HEXCOLOR(0x999999)

@interface WARUserEditBaseViewController : WARBaseShadowController

@property (nonatomic, strong) WARUserEditDataManager *dataManager;
@property (nonatomic, assign) BOOL valueChanged;

- (void)initUI;

@end
