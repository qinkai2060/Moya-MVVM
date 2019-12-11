//
//  WARProfileNetWorkTool.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import <Foundation/Foundation.h>
typedef void(^ WARProfileNetWorkToolCallback)(id responseObj, NSError *err);
@interface WARProfileNetWorkTool : NSObject
+ (void)getphotoGroupArray:(NSString *)url photoID:(NSString*)accountID callback:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)postCreatPhoto:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)deletPhotoGroupId:(NSString *)albumID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)postPhotoDetailId:(NSString*)albumID params:(NSDictionary *)parms CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)putEditingPhoto:(NSString*)albumID params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
+ (void)deleteSelectPhotos:(NSArray*)photosIds photoID:(NSString*)albumID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;

+ (void)putMovePhotoGroup:(NSString*)orginID photos:(NSArray*)photosIds newAlbumID:(NSString*)newAlbumID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 上传
 **/
+ (void)postPhotos:(NSString*)albumID params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 自己主页
 **/
+ (void)getUserInfoWithCallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
//  comment-app/{module}/thumb/{itemId}/thumb/{thumbState}
/**
 点赞
 **/
+ (void)postthumbClickLikeWith:(NSString*)itemId atThumbState:(NSString*)state params:(NSDictionary*)params CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 描述照片
 **/
+ (void)putPhotoDescritionWithAlbumId:(NSString*)albumID atPictureId:(NSString*)pictureId atDesc:(NSString*)desc CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 移动照片
 **/
+ (void)putPhotoCoverWithAlbumID:(NSString*)albumID atPictureId:(NSString*)pictureID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 加关注
 **/
+ (void)postSendFollowWithGuid:(NSString*)guyId atOperation:(NSString*)operateSide CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 他人主页
 **/
+ (void)postSendAddFriendID:(NSString*)friendId atMaskId:(NSString*)maskId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
/**
 加好友
 **/
+ (void)getOtherPersonDataWithguyId:(NSString*)guyId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;

/**
 照片列表
 @param successblock
 @param failerblock 
 */
+ (void)postPhotoListWithAtWithLastShootTime:(NSString*)lastShootTime atlastFindId:(NSString *)lastFindId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock ;

/**
 视频列表

 @param successblock
 @param failerblock 
 */
+ (void)postVideoListWithLastShootTime:(NSString*)lastShootTime atlastFindId:(NSString *)lastFindId CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock ;
/**
 相册排序
 
 @param successblock
 @param failerblock
 */
+ (void)putSortGroupPhoto:(NSArray*)albumIDArr params:(NSDictionary*)dict CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;

+ (void)getPhotoCommentCount:(NSString*)albumId atPictureId:(NSString*)pictureId atWithAccountID:(NSString*)accountID CallBack:(void(^)(id response))successblock failer:(void(^)(id response))failerblock;
@end
