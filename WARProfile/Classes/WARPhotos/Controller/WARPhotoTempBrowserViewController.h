//
//  WARPhotoTempBrowserViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/4.
//
#import "WARPhotoBaseViewController.h"
#import "WARPhotoListModel.h"
@interface WARPhotoTempBrowserViewController : WARPhotoBaseViewController
- (instancetype)initWithModel:(WARGroupModel *)model atCurrentindex:(NSInteger)currimgeindex  atImagePictureArray:(NSArray*)imageArray atAccountID:(NSString *)accountId;
@end
