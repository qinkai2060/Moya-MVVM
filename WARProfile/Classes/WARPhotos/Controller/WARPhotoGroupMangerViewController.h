//
//  WARPhotoGroupMangerViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARPhotoBaseViewController.h"
@class WARGroupModel;
typedef void (^downCountBlock)(WARGroupModel *model);
@interface WARPhotoGroupMangerViewController : WARPhotoBaseViewController
/**选中数组*/
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,copy) downCountBlock block;
@end
