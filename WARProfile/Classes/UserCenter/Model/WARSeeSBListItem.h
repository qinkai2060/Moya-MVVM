//
//  WARSeeSBListItem.h
//  Pods
//
//  Created by huange on 2017/8/11.
//
//

#import <Foundation/Foundation.h>

@interface WARSeeSBListItem : NSObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *headerID;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString *gender;

- (instancetype)initWithDict:(NSDictionary*)userDict;

@end
