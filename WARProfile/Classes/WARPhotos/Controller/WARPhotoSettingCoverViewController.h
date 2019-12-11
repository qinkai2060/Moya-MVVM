//
//  WARPhotoSettingCoverViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/14.
//

#import "WARPhotoBaseViewController.h"
typedef  void(^CoverSettingBlock)(NSString *coverID);
@interface WARPhotoSettingCoverViewController : WARPhotoBaseViewController
@property(nonatomic,copy)CoverSettingBlock CoverSettingBlock;
@end
