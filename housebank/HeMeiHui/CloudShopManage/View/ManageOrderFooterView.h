//
//  ManageOrderFooterView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageOrderFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) ManageOrderModel * footerModel;
@end

NS_ASSUME_NONNULL_END
