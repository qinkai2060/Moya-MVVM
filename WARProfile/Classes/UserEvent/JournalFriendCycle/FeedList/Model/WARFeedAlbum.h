//
//  WARFeedAlbumComponent.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import <Foundation/Foundation.h>

@interface WARFeedAlbum : NSObject
/** 相册ID */
@property (nonatomic, copy) NSString *albumId;
/** 收藏夹ID */
@property (nonatomic, copy) NSString *favourId;
/** 封面Id */
@property (nonatomic, copy) NSString *coverId;
/** 相册名 */
@property (nonatomic, copy) NSString *name;
/** 照片数量 */
@property (nonatomic, assign) NSInteger photoCount;

@end
