//
//  AssembleSubViewTool.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssembleSubViewTool : NSObject

/*弹出拼团规则视图*/
+(void)showReluerSubView:(NSInteger)content activeType:(NSInteger)activeType;
/*弹出正在拼团列表*/
+(void)showAssembleListSubView:(id)model;
/*弹出拼团攻略*/
+(void)showAssembleStrategySubView:(id)content;
@end

NS_ASSUME_NONNULL_END
