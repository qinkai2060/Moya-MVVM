//
//  WARPrivatePersonListViewController.h
//  WARProfile
//
//  Created by Hao on 2018/6/29.
//

#import "WARBaseViewController.h"

typedef NS_ENUM(NSInteger, WARPrivatePersonType) {
    WARPrivatePersonTypeBlack,  // 黑名单
    WARPrivatePersonTypeMomentNoAccess,  // 不让TA看我的动态
    WARPrivatePersonTypeMomentNoReceive,  // 不看TA的动态
    WARPrivatePersonTypeLocationNoShow,  // 对TA隐身
};

@interface WARPrivatePersonListViewController : WARBaseViewController

@property (nonatomic, assign) WARPrivatePersonType type;

@end
