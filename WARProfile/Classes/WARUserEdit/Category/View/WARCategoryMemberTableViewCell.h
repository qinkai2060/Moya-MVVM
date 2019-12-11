//
//  WARCategoryMemberTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <UIKit/UIKit.h>

@class WARContactCategoryModel;

typedef void(^WARCategoryMemberTableViewCellDidEditBlock)(NSDictionary *dic,NSArray *addArr,NSArray *removeArr);
typedef void(^WARCategoryMemberTableViewCellDidFinishBlock)(NSArray *addArr,NSArray *removeArr);


@interface WARCategoryMemberTableViewCell : UITableViewCell


@property (nonatomic, copy)WARCategoryMemberTableViewCellDidEditBlock didEditBlock;
@property (nonatomic, copy)WARCategoryMemberTableViewCellDidFinishBlock didFinishBlock;


- (void)configureMembers:(NSArray *)members categoryModel:(WARContactCategoryModel *)categoryModel;
@end
