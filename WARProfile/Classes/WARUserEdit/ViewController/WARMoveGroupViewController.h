//
//  WARMoveGroupViewController.h
//  Pods
//
//  Created by 秦恺 on 2018/3/14.
//

#import "WARUserEditBaseViewController.h"
#import "WARGroupView.h"
@interface WARMoveGroupViewController : UIViewController
@property (nonatomic, copy)NSString *currentCategoryId;
@property (nonatomic, copy)NSString *accountId;

@end
@interface WARMoveGroupViewHeaderV :UIView
@property(nonatomic,strong)WARGroupView *groupView;
@end
