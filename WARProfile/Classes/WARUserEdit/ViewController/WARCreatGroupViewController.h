//
//  WARCreatGroupViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/13.
//

#import "WARUserEditBaseViewController.h"
typedef void (^CallBack)();
@interface WARCreatGroupViewController : WARUserEditBaseViewController
@property (nonatomic,copy)CallBack callback;
@end
