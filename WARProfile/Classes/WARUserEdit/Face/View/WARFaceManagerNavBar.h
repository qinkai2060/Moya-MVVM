//
//  WARFaceManagerNavBar.h
//  WARContacts
//
//  Created by Hao on 2018/7/20.
//

#import <UIKit/UIKit.h>

typedef void (^WARFaceManagerNavBaDidClickButtonBlock) ();

@interface WARFaceManagerNavBar : UIView

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backArrowButon;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, copy) WARFaceManagerNavBaDidClickButtonBlock backBlock;
@property (nonatomic, copy) WARFaceManagerNavBaDidClickButtonBlock saveBlock;

@end
