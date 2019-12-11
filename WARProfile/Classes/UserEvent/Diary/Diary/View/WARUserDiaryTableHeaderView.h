//
//  WARUserDiaryTableHeaderView.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/24.
//

#import <UIKit/UIKit.h>


typedef void(^WARUserDiaryTableHeaderViewDidClickReleaseNewDiaryBlock)();
typedef void(^WARUserDiaryTableHeaderViewDidClickInputPhotosBlock)();

@interface WARUserDiaryTableHeaderView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy)WARUserDiaryTableHeaderViewDidClickReleaseNewDiaryBlock didClickReleaseNewDiaryBlock;
@property (nonatomic, copy)WARUserDiaryTableHeaderViewDidClickInputPhotosBlock didClickInputPhotosBlock;

@property (nonatomic, copy)NSArray *weathers;
@property (nonatomic, assign) BOOL  isShowInputPhotoBtn;
@property (nonatomic,assign) BOOL isScrollIng;

@end
