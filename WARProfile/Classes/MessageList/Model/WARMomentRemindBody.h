//
//  WARMomentRemindBody.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>

//TEXT, LINK, PICTURE, VIDEO;
#define WARMoment_RemindBody_Text       @"TEXT"
#define WARMoment_RemindBody_Link      @"LINK"
#define WARMoment_RemindBody_Picture       @"PICTURE"
#define WARMoment_RemindBody_Video       @"VIDEO"

typedef NS_ENUM(NSUInteger, WARMomentRemindBodyType) {
    WARMomentRemindBodyTypeText,
    WARMomentRemindBodyTypeLink,
    WARMomentRemindBodyTypePicture,
    WARMomentRemindBodyTypeVideo,
};

@interface WARMomentRemindBody : NSObject

/** 发日志的人的Id */
@property (nonatomic, copy) NSString *accId;
/** body */
@property (nonatomic, copy) NSString *body;
/** momentId */
@property (nonatomic, copy) NSString *momentId;
/** type */
@property (nonatomic, copy) NSString *type;

/** 辅助字段 */
/** bodyType */
@property (nonatomic, assign) WARMomentRemindBodyType bodyTypeEnum;
/** linkBodyAttributeString */
@property (nonatomic, strong) NSAttributedString *linkBodyAttributeString;
/** bodyAttributeString */
@property (nonatomic, strong) NSAttributedString *bodyAttributeString;
@end
