//
//  WARNewUserDiaryTableHeaderPhotoView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import <UIKit/UIKit.h>

@interface WARNewUserDiaryTableHeaderPhotoView : UIView

@property (nonatomic, copy)NSArray *photos;

- (void)reloadData;

@end


#pragma mark - WARNewUserDiaryTableHeaderPhotoViewCell

@interface WARNewUserDiaryTableHeaderPhotoViewCell : UICollectionViewCell

@end
