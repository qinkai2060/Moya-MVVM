//
//  WARFeedAlbumLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/25.
//

#import <Foundation/Foundation.h>
#import "WARFeedAlbum.h"

@interface WARFeedAlbumLayout : NSObject
/** album */
@property (nonatomic, strong) WARFeedAlbum *album;

+ (WARFeedAlbumLayout *)albumLayout:(WARFeedAlbum *)album;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect countFrame;
@property (nonatomic, assign) CGRect shadowLayerFrame;

@property (nonatomic, assign) CGFloat contentHeight;

@end
