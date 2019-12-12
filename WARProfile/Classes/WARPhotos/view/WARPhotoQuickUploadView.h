//
//  WARPhotoQuickUploadView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import <UIKit/UIKit.h>
@class WARPhotoQuickUploadView;
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "WARPhotosQView.h"
@protocol WARPhotoQuickUploadViewDelegate<NSObject>
- (void)photoQuickUploadViewBegan:(WARPhotoQuickUploadView*)view point:(CGPoint)point gesture:(UILongPressGestureRecognizer *)gesture data:(id)data;
- (void)photoQuickUploadViewChange:(WARPhotoQuickUploadView*)view point:(CGPoint)point gesture:(UILongPressGestureRecognizer *)gesture data:(id)data isDraging:(BOOL)isDraging;
- (void)photoQuicUploadViewEnd:(WARPhotoQuickUploadView*)view point:(CGPoint)point gesture:(UILongPressGestureRecognizer *)gesture data:(id)data isDraging:(BOOL)isDraging;
@end
typedef void(^WARPhotoQuickUploadViewCloseBlock)();
@interface WARPhotoQuickUploadView : UIView<XTSegmentControlDelegate,WARPhotosQViewDelegate>
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIView *cornerView;
@property (nonatomic,strong) UILabel *tipsLb;
@property (nonatomic,strong) UIView *tempView;
@property (nonatomic,strong) XTSegmentControl *segmentControl;
//@property (nonatomic,strong)iCarousel *icarourser;
@property (nonatomic,strong) WARPhotosQView *PhotosQView;
@property (nonatomic,  weak) id<WARPhotoQuickUploadViewDelegate> delegate;
@property (nonatomic,  copy) WARPhotoQuickUploadViewCloseBlock closeBlock;
@property (nonatomic,strong) NSArray *segmentCotrolArr;
@property (nonatomic,strong) NSArray *compareArr;
- (instancetype)initWithFrame:(CGRect)frame atWithSegementArr:(NSArray*)array atCompareArr:(NSArray*)compareArray;
@end
