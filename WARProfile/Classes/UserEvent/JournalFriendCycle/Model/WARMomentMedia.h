//
//  WARMomentMedia.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>

@interface WARMomentMedia : NSObject

@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* imgH;
@property (nonatomic, copy) NSString* imgId;
@property (nonatomic, copy) NSString* imgW;

/** 辅助字段 */
@property (nonatomic, strong) NSURL* imageURL;
@property (nonatomic, strong) NSURL* originalImgURL;
@property (nonatomic, strong) NSURL* videoURL;

@end
