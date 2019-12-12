//
//  WARMomentTools.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/23.
//

#import <Foundation/Foundation.h>

typedef void(^ActionSheetCompleteHandler)(NSUInteger index);

@interface WARMomentTools : NSObject

+ (void)showDeleteActionSheetWithActionHandler:(ActionSheetCompleteHandler)actionHandler;

@end
