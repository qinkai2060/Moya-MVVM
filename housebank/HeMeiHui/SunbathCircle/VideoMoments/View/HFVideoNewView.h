//
//  HFVideoNewView.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPLayer/ZFPlayerController.h>
#import "ZFPlayerControl.h"
@class ZFTableData;
NS_ASSUME_NONNULL_BEGIN

@interface HFVideoNewView : UITableView
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray <ZFTableData *>*dataSourceD;
@property(nonatomic,strong)ZFPlayerControl *playerControl;
@property (nonatomic, strong) ZFPlayerController *player;
@end

NS_ASSUME_NONNULL_END
