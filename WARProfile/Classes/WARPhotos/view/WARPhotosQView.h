//
//  WARPhotosQView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import <UIKit/UIKit.h>
#import "WARPhotosCollectionView.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
@class WARPhotosQView;
@protocol WARPhotosQViewDelegate<NSObject>
- (void)WARPhotosQView:(WARPhotosQView*)photoQView willDisplay:(NSInteger)sectionIndex;
- (void)gestureBegan:(WARPhotosQView *)collectionView tempview:(UIView *)tempView data:(id)modelData;
- (void)gestureChange:(WARPhotosQView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point data:(id)modelData;
- (void)gestureEnd:(WARPhotosQView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point data:(id)modelData;
@end
@interface WARPhotosQView : UIView<WARPhotosCollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)WARPhotosCollectionView *collectionView;
@property (nonatomic,weak)id<WARPhotosQViewDelegate> delegate;

@property (nonatomic,strong) NSArray *photoArray;
@end
