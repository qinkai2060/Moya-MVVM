//
//  WARProfilePersonalCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import <UIKit/UIKit.h>
#import "WARProfileUserModel.h"//WARProfileUserMasksModel
@interface WARProfilePersonalCell : UITableViewCell
/** name */
@property (nonatomic, strong) UILabel *namelb;
/** info */
@property (nonatomic, strong) UILabel *infolb;

@property (nonatomic, strong) WARProfileUserMasksModel *model;
@end
