//
//  WARUserInfoBaseViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/30.
//

#import <UIKit/UIKit.h>
#import "WARBaseViewController.h"

#import "WARAlertView.h"
#import "WARUIHelper.h"
#import "WARMacros.h"

@interface WARUserInfoBaseViewController : WARBaseViewController


@property (nonatomic, copy) NSString *rightButtonText;

@property (nonatomic, assign) BOOL valueChanged;

@end
