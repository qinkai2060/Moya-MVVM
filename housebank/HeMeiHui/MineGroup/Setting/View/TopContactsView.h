//
//  TopContactsView.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopContactsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TopContactsViewCellBlock)(TopContactsModel *model);//编辑
typedef void(^TopContactsViewCreateBlock)(void);//新建

@interface TopContactsView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrDateSoure;
@property (nonatomic, copy) TopContactsViewCellBlock cellBlock;
@property (nonatomic, copy) TopContactsViewCreateBlock createBlock;

@end

NS_ASSUME_NONNULL_END
