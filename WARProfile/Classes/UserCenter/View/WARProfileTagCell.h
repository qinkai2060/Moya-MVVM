//
//  WARProfileTagCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import <UIKit/UIKit.h>
#import "WARProfileUserModel.h"
@interface WARProfileTagCell : UITableViewCell
/** name */
@property (nonatomic, strong) UILabel *namelb;
@property (nonatomic, strong) WARProfileUserMasksModel *model;
@end
