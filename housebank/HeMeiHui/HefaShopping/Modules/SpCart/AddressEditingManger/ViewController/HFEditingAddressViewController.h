//
//  HFEditingAddressViewController.h
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFViewController.h"
@class HFAddressModel;
@protocol HFEditingAddressViewControllerDelegate <NSObject>

- (void)backMangeEditinAddress:(HFAddressModel*)model;

@end
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HFEditingEnterSource) {
    HFEditingEnterSourceAdd = 0,
    HFEditingEnterSourceEditing = 1,
};

@interface HFEditingAddressViewController :HFViewController
@property(nonatomic,assign) HFEditingEnterSource source;
@property(nonatomic,weak) id <HFEditingAddressViewControllerDelegate> delegate;
- (void)editingOringModel:(HFAddressModel*)model;
@end

NS_ASSUME_NONNULL_END
