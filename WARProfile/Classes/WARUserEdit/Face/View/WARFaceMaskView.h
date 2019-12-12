//
//  WARFaceMaskView.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WARFaceMaskViewType) {
    WARFaceMaskViewTypeOfFaceMask,
    WARFaceMaskViewTypeOfContactCategory,
};


typedef void(^WARFaceMaskViewDidClickAddNewFaceBlock)();
typedef void(^WARFaceMaskViewDidClickEditFaceBlock)();
typedef void(^WARFaceMaskViewDidScrollItemBlock)(NSInteger itemIndex);
typedef void(^WARFaceMaskViewDidLongPreCellBlcok)(NSIndexPath *indexPath);

@interface WARFaceMaskView : UIView

@property (nonatomic, copy)WARFaceMaskViewDidClickAddNewFaceBlock didClickAddNewFaceBlock;
@property (nonatomic, copy)WARFaceMaskViewDidClickEditFaceBlock didClickEditFaceBlock;
@property (nonatomic, copy)WARFaceMaskViewDidScrollItemBlock didScrollItemBlock;
@property (nonatomic, copy)WARFaceMaskViewDidLongPreCellBlcok didLongPreCellBlcok;

@property (nonatomic, copy)NSArray *dataArr;
@property (nonatomic, assign) WARFaceMaskViewType type;

- (void)reloadFaces;
- (void)autoScrollToIndex:(NSInteger)index;
@end
