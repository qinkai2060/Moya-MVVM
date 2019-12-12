//
//  WARMomentUser.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>

@interface WARMomentUser : NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *lastId;
@property (nonatomic, copy) NSString *headId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *sign;

/** 辅助字段 */
@property (nonatomic, strong) NSURL *headUrl; 
@property (nonatomic, copy) NSString *friendName;
@end
