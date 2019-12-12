//
//  WARPhotoSettingAuthViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoBaseViewController.h"
typedef void (^WARSettingAuthBlock) (NSString *type);
@interface WARPhotoSettingAuthViewController : WARPhotoBaseViewController
@property(nonatomic,copy)WARSettingAuthBlock authBlock;
- (instancetype)initWith:(NSString *)authType;
@end
