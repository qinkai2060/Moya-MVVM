//
//  WARUserSettingHeaderCell.h
//  WARProfile
//
//  Created by Hao on 2018/7/6.
//

#import <UIKit/UIKit.h>

typedef void (^WARUserSettingHeaderCellDidClickBlock) (void);

@interface WARUserSettingHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, copy) WARUserSettingHeaderCellDidClickBlock leftBlock;
@property (nonatomic, copy) WARUserSettingHeaderCellDidClickBlock addBlock;

@end
