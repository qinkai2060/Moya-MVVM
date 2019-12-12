//
//  WARChangePhoneNumCell.h
//  WARProfile
//
//  Created by Hao on 2018/6/28.
//

#import <UIKit/UIKit.h>

typedef void (^WARChangePhoneNumCellDidButtonBlock)(void);

@interface WARChangePhoneNumCell : UITableViewCell

@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) WARChangePhoneNumCellDidButtonBlock rightButtonBlock;

@end
