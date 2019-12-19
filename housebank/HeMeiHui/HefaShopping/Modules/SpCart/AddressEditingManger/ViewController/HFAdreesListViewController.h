//
//  HFAdreesListViewController.h
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFAddressModel;
#import "HFAddressListViewModel.h"
@protocol HFAdreesListViewControllerDelegate <NSObject>

- (void)backMangeAddress:(HFAddressModel*)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HFAdreesListViewController : UIViewController
@property (nonatomic,strong)HFAddressListViewModel *viewModel;
@property(nonatomic,weak) id <HFAdreesListViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
