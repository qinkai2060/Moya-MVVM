//
//  FindRegionsModel.h
//  housebank
//
//  Created by liqianhong on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindRegionsModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *parentId;//c城市ID
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *py;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *hidden;

@end

NS_ASSUME_NONNULL_END
