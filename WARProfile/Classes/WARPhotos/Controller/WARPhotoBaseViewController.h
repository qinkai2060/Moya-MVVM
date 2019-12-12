//
//  WARPhotoBaseViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import <UIKit/UIKit.h>
#import "WARNavgationCutsomBar.h"
#import "WARGroupModel.h"
@interface WARPhotoBaseViewController : UIViewController
@property (nonatomic,strong)WARNavgationCutsomBar *customBar;
- (instancetype)initWithModel:(WARGroupModel*)model;
- (void)leftAtction;
- (void)rightAction;
@end
