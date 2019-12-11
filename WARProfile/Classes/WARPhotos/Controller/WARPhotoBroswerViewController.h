//
//  WARPhotoBroswerViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import "WARPhotoBaseViewController.h"

@interface WARPhotoBroswerViewController : WARPhotoBaseViewController
- (instancetype)initWithModel:(WARGroupModel *)model currentimgev:(UICollectionView *)currentimgv currentindex:(NSInteger)currimgeindex pictureDescrtionModel:(WARPictureModel*)picturemodel atImagePictureArray:(NSArray*)imageArray atSuperView:(UIView*)superView atAccountID:(NSString*)accountId;
@end
