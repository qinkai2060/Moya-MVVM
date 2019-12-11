//
//  WARCommonListTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WARCommonListTableViewCellType) {
    WARCommonListTableViewCellTypeOfCreate = 0,
    WARCommonListTableViewCellTypeOfNormal,
};




@interface WARCommonListTableViewCell : UITableViewCell

@property (nonatomic, assign) WARCommonListTableViewCellType  type;

@property (nonatomic, strong) UIImageView *rightImgV;
@property (nonatomic, strong) UILabel *createLab;

- (void)configureText:(NSString *)text;
- (void)configureSelectStateWithArray:(NSArray *)array isMulti:(BOOL)isMulti;

@end



typedef void(^WAREditTagsTableCellDidSelectTagBlock)(NSInteger index);
typedef void(^WAREditTagsTableCellDidFinishEditBlock)();

@interface WAREditTagsTableCell : UITableViewCell

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy)WAREditTagsTableCellDidSelectTagBlock didSelectTagBlock;
@property (nonatomic, copy)WAREditTagsTableCellDidFinishEditBlock didFinishEditBlock;


- (void)configureDataArr:(NSArray *)dataArr;

@end



@interface WARInputTableCell :UITableViewCell



@end
