//
//  EditTopContactsViewController.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
#import "TopContactsModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^EditTopContactsViewControllerRefrensh)();
@interface EditTopContactsViewController : BaseSettingViewController
@property (nonatomic, strong) TopContactsModel *model;
/**
 传过来的navigation title
 */
@property (nonatomic, strong) NSString *ntitle;

@property (nonatomic, copy) EditTopContactsViewControllerRefrensh refrenshBlock;
@end

NS_ASSUME_NONNULL_END
