//
//  WARUserSettingSwitchCell.h
//  WARProfile
//
//  Created by Hao on 2018/6/20.
//

#import <UIKit/UIKit.h>

typedef void (^WARUserSettingSwitchCellSwitchDidValueChangedBlock) (BOOL isOn);

@interface WARUserSettingSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellDetailLabel;
@property (nonatomic, strong) UISwitch *item;

@property (nonatomic, copy) WARUserSettingSwitchCellSwitchDidValueChangedBlock switchBlock;

@end
