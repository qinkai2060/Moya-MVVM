//
//  WARCategoryMemberCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <UIKit/UIKit.h>

@class WARCategoryViewModel;


typedef NS_ENUM(NSInteger,WARCategoryMemberCellType) {
    WARCategoryMemberCellTypeOfMember,
    WARCategoryMemberCellTypeOfOther,
};

@interface WARCategoryMemberCell : UICollectionViewCell

@property (nonatomic, assign) WARCategoryMemberCellType  type;
@property (nonatomic, assign) BOOL  isEdit;
- (void)configureCategoryMember:(WARCategoryViewModel *)categoryMember;


@end
