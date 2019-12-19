//
//  FindRegionsModel.m
//  housebank
//
//  Created by liqianhong on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "FindRegionsModel.h"

@implementation FindRegionsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.pinyin forKey:@"pinyin"];
    [aCoder encodeObject:self.py forKey:@"py"];
    [aCoder encodeObject:self.sort forKey:@"sort"];
    [aCoder encodeObject:self.lng forKey:@"lng"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.hidden forKey:@"hidden"];

    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.pinyin = [aDecoder decodeObjectForKey:@"pinyin"];
        self.py = [aDecoder decodeObjectForKey:@"py"];
        self.sort = [aDecoder decodeObjectForKey:@"sort"];
        self.lng = [aDecoder decodeObjectForKey:@"lng"];
        self.lat = [aDecoder decodeObjectForKey:@"lat"];
        self.hidden = [aDecoder decodeObjectForKey:@"hidden"];
    }
    return self;
}

@end
