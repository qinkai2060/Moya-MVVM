//
//  WARUserPrivateStateViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import <UIKit/UIKit.h>
#import "WARUserInfoBaseViewController.h"

typedef void(^WARUserPrivateStateViewControllerDidSelectStateBlock)(NSString *string);

@interface WARUserPrivateStateViewController : WARUserInfoBaseViewController

@property (nonatomic, copy)WARUserPrivateStateViewControllerDidSelectStateBlock didSelectStateBlock;

- (instancetype)initWithStateStr:(NSString *)stateStr showStateStr:(NSString *)showStateStr;


@end
