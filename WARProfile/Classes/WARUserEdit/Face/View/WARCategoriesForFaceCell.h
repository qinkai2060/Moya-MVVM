//
//  WARCategoriesForFaceCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WARCategoriesForFaceCellType){
    WARCategoriesForFaceCellTypeOfRightImg,              //右边带箭头
    WARCategoriesForFaceCellTypeOfNormal,                //只有tagView
    WARCategoriesForFaceCellTypeOfDifferentState,        //tagView不同点击状态
};


typedef void(^WARCategoriesForFaceCellOfDifferentStateDidSelectBlock)(NSInteger index);
typedef void(^WARCategoriesForFaceCellOfNormalDidSelectBlock)(NSInteger index);


@interface WARCategoriesForFaceCell : UITableViewCell

@property (nonatomic, copy)WARCategoriesForFaceCellOfDifferentStateDidSelectBlock differentStateDidSelectBlock;

@property (nonatomic, copy)WARCategoriesForFaceCellOfNormalDidSelectBlock normalDidSelectBlock;

@property (nonatomic, assign) WARCategoriesForFaceCellType  cellType;

- (void)configureCategories:(NSArray *)categories;


@end




typedef void(^WARUserBgImgForFaceCellDidLongPreImgBlock)();

@interface WARUserBgImgForFaceCell : UITableViewCell

@property (nonatomic, copy)WARUserBgImgForFaceCellDidLongPreImgBlock didLongPreImgBlock;

- (void)configureBgImgWithBgImgId:(NSString *)bgImgId;
@end




@interface WARNoCategoriesForFaceCell : UITableViewCell


@end

