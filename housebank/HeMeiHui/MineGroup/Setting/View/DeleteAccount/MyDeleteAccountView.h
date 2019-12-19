//
//  MyDeleteAccountView.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDeletAcountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyDeleteAccountView : UIView
@property(nonatomic,strong)NSArray<MyDeletAcountModel*> *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *btn;

@end

NS_ASSUME_NONNULL_END
