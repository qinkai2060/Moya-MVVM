//
//  NIMContactTools.h
//  HeMeiHui
//
//  Created by 任为 on 2017/11/15.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHContactTabViewController.h"

@interface NIMContactTools : NSObject
@property (nonatomic,strong)HMHContactTabViewController *contactTab;
+(instancetype)shareTools;
@end
