//
//  WARProfileNetWorkTool.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import "WARProfileNetWorkTool.h"
#import "WARNetwork.h"
#import "WARMacros.h"
@implementation WARProfileNetWorkTool
+ (void)getphotoGroupArray:(NSString *)url photoID:(NSString*)accountID callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock
{
    [WARNetwork getDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album?friendId=%@",kDomainNetworkUrl,accountID] params:@{} completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
    
}
+ (void)postCreatPhoto:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"userhub-app/album"] params:dict completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)deletPhotoGroupId:(NSString *)albumID CallBack:(void (^)(id))successblock failer:(void (^)(id))failerblock{
    [WARNetwork deleteDataFromURI:[NSString stringWithFormat:@"%@/%@/%@",kDomainNetworkUrl,@"userhub-app/album",albumID] params:nil completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)postPhotoDetailId:(NSString*)albumID params:(NSDictionary *)parms CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/%@/%@/%@",kDomainNetworkUrl,@"userhub-app/album",albumID,@"picture/list"] params:parms completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}

+ (void)putEditingPhoto:(NSString*)albumID params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/%@/%@",kDomainNetworkUrl,@"userhub-app/album",albumID] params:dict completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+(void)deleteSelectPhotos:(NSArray*)photosIds photoID:(NSString*)albumID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    NSString *url  = [NSString stringWithFormat:@"%@/%@/%@/picture/delete",kDomainNetworkUrl,@"userhub-app/album",albumID];
    
    [WARNetwork postDataFromURI:url params:photosIds completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)putMovePhotoGroup:(NSString*)orginID photos:(NSArray*)photosIds newAlbumID:(NSString*)newAlbumID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/%@/picture/move/%@",kDomainNetworkUrl,orginID,newAlbumID] params:photosIds completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)postPhotos:(NSString*)albumID params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/%@/%@/%@",kDomainNetworkUrl,@"userhub-app/album",albumID,@"picture"] params:dict completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)getUserInfoWithCallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    [WARNetwork getDataFromURI:[NSString stringWithFormat:@"%@/cont-app/user/profile/home",kDomainNetworkUrl] params:@{} completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
//  comment-app/{module}/thumb/{itemId}/thumb/{thumbState}
+ (void)postthumbClickLikeWith:(NSString*)itemId atThumbState:(NSString*)state params:(NSDictionary*)params CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    NSString *url  = [NSString stringWithFormat:@"%@/comment-app/ALBUMPIC/thumb",kDomainNetworkUrl];
    
    [WARNetwork postDataFromURI:url params:params completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];

}
+ (void)putPhotoDescritionWithAlbumId:(NSString*)albumID atPictureId:(NSString*)pictureId atDesc:(NSString*)desc CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/%@/picture/%@/desc",kDomainNetworkUrl,albumID,pictureId] params:@{@"desc":desc} completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)putPhotoCoverWithAlbumID:(NSString*)albumID atPictureId:(NSString*)pictureID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/%@/cover/%@",kDomainNetworkUrl,albumID,pictureID] params:@{} completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)postSendFollowWithGuid:(NSString*)guyId atOperation:(NSString*)operateSide CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    NSString *url  = [NSString stringWithFormat:@"%@/cont-app/follow/%@/%@",kDomainNetworkUrl,guyId,operateSide];
    
    [WARNetwork postDataFromURI:url params:@{} completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)getOtherPersonDataWithguyId:(NSString*)guyId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    [WARNetwork getDataFromURI:[NSString stringWithFormat:@"%@/cont-app/someone/profile/home/%@",kDomainNetworkUrl,guyId] params:@{} completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
+ (void)postSendAddFriendID:(NSString*)friendId atMaskId:(NSString*)maskId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/cont-app/friend/apply",kDomainNetworkUrl] params:@{@"friendId":friendId} completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)postPhotoListWithAtWithLastShootTime:(NSString*)lastShootTime atlastFindId:(NSString *)lastFindId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    NSDictionary *parms = @{@"lastShootTime":lastShootTime.length == 0 ?@"":lastShootTime,@"lastFindId":lastFindId.length == 0 ?@"":lastFindId};
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/pure/picture/list",kDomainNetworkUrl] params:parms completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)postVideoListWithLastShootTime:(NSString*)lastShootTime atlastFindId:(NSString *)lastFindId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
       NSDictionary *parms = @{@"lastShootTime":lastShootTime.length == 0 ?@"":lastShootTime,@"lastFindId":lastFindId.length == 0 ?@"":lastFindId};
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/pure/video/list",kDomainNetworkUrl] params:parms completion:^(id responseObj, NSError *err) {
        
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}

+ (void)putSortGroupPhoto:(NSArray*)albumIDArr params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock{
    
    [WARNetwork putDataFromURI:[NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"userhub-app/album/sort"] params:albumIDArr completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
    }];
}
+ (void)getPhotoCommentCount:(NSString*)albumId atPictureId:(NSString*)pictureId atWithAccountID:(NSString*)accountID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock {
    [WARNetwork postDataFromURI:[NSString stringWithFormat:@"%@/userhub-app/album/picture/detail",kDomainNetworkUrl,albumId,pictureId,pictureId] params:@{@"albumId":albumId,@"pictureId":pictureId,@"friendId":accountID} completion:^(id responseObj, NSError *err) {
        if (!err) {
            successblock(responseObj);
        }else{
            failerblock(err);
        }
        
    }];
}
@end
