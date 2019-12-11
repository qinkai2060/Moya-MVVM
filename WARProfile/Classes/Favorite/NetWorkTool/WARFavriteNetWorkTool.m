//
//  WARFavriteNetWorkTool.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/16.
//

#import "WARFavriteNetWorkTool.h"
#import "WARNetwork.h"
#import "WARMacros.h"
@implementation WARFavriteNetWorkTool
+ (void)putFavriteEditingWithFavoriteId:(NSString*)favoriteId byParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/favorite-app/favorite/%@",kDomainNetworkUrl,favoriteId] params:params completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}

+ (void)postFavriteCreatWithParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/favorite-app/favorite",kDomainNetworkUrl] params:params completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
+ (void)deleteFavriteCreatWithFavoriteId:(NSString*)favoriteId byParams:(NSDictionary*)params callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    [WARNetwork deleteDataFromURI:[NSString stringWithFormat:@"%@/favorite-app/favorite/%@",kDomainNetworkUrl,favoriteId] params:params completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
+ (void)postFavoriteDatalistWithLastCreateTime:(NSString*)lastCreateTime lastType:(NSString*)lastType callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/favorite-app/favorite/list",kDomainNetworkUrl] params:nil completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
+ (void)postFavoriteDatalistWithlistWithcallback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/favorite-app/favorite/synopsis/list",kDomainNetworkUrl] params:nil completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
@end
