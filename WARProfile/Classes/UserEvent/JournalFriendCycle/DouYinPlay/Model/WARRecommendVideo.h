//
//  WARRecommendVideo.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import <Foundation/Foundation.h>
#import "WARCommentWrapper.h"
#import "WARMomentUser.h"

@interface WARRecommendVideo : NSObject
/** account */
@property (nonatomic, strong) WARMomentUser *account;
/** commentWapper */
@property (nonatomic, strong) WARCommentWrapper *commentWapper;
/** desc */
@property (nonatomic, copy) NSString *desc;
/** url */
@property (nonatomic, copy) NSString *url;

/** 辅助字段 */
/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** url */
@property (nonatomic, strong) NSURL *videoURL;
/** momentId */
@property (nonatomic, copy) NSString *belongMomentId;
@end
