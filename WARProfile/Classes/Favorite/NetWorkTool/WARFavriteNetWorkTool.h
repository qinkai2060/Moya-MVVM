//
//  WARFavriteNetWorkTool.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/16.
//

#import <Foundation/Foundation.h>
typedef void(^ WARFavriteNetWorkToolCallback)(id responseObj, NSError *err);
@interface WARFavriteNetWorkTool : NSObject
+ (void)putFavriteEditingWithFavoriteId:(NSString*)favoriteId byParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)postFavriteCreatWithParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)deleteFavriteCreatWithFavoriteId:(NSString*)favoriteId byParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)postFavoriteDatalistWithLastCreateTime:(NSString*)lastCreateTime lastType:(NSString*)lastType callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock ;
+ (void)postFavoriteDatalistWithlistWithcallback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
@end
