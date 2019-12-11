//
//  WARFaceBaseViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/23.
//

#import <UIKit/UIKit.h>
#import "WARBaseViewController.h"
#import "WARAlertView.h"
#import "WARProgressHUD.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "UIImageView+WebCache.h"
#import "WARActionSheet.h"

#import "ReactiveObjC.h"

#import "WARContactCategoryModel.h"
#import "WARFaceMaskModel.h"


@interface WARFaceBaseViewController : WARBaseViewController

@property (nonatomic, copy) NSString *rightButtonText;

@property (nonatomic, assign) BOOL valueChanged;

@end
