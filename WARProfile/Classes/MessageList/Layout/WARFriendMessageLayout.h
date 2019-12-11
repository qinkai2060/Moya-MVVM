//
//  WARFriendMessageLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "WARMomentRemind.h"

@interface WARFriendMessageLayout : NSObject

/** 消息提醒 */
@property (nonatomic, strong) WARMomentRemind *remind;

+ (WARFriendMessageLayout *)remindLayout:(WARMomentRemind *)remind;

@property (nonatomic, assign) CGRect userIconF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect commentViewF;
@property (nonatomic, assign) CGRect subContentIconF;
@property (nonatomic, assign) CGRect subContentVideoIconF;
@property (nonatomic, assign) CGRect subContentLableF;
@property (nonatomic, assign) CGRect commentContentLableF;
@property (nonatomic, assign) CGRect commentContentMediaF;
@property (nonatomic, assign) CGRect praiseIconF;
@property (nonatomic, assign) CGRect timeLableF;
@property (nonatomic, assign) CGRect lineF;

@property (nonatomic, assign) CGFloat cellHeight;
@end
