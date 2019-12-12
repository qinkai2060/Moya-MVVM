//
//  WARSeeSBListItem.m
//  Pods
//
//  Created by huange on 2017/8/11.
//
//

#import "WARSeeSBListItem.h"

@implementation WARSeeSBListItem

- (instancetype)initWithDict:(NSDictionary*)userDict {
    self = [super init];
    if (self) {
        [self dataWithDict:userDict];
    }
    
    return self;
}

- (void)dataWithDict:(NSDictionary *)userDict {
    NSString *idSting = [userDict objectForKey:@"accountId"];
    NSString *daySting = [userDict objectForKey:@"day"];
    NSString *genderSting = [userDict objectForKey:@"gender"];
    NSString *headIdSting = [userDict objectForKey:@"headId"];
    NSString *nicknameSting = [userDict objectForKey:@"nickname"];
    NSString *signatureSting = [userDict objectForKey:@"signature"];
    NSString *yearSting = [userDict objectForKey:@"year"];
    NSString *month = [userDict objectForKey:@"month"];


    if (idSting && ![idSting isKindOfClass:[NSNull class]]) {
        self.accountId = idSting;
    }else {
        self.accountId = @"";
    }
    
    if (month && ![month isKindOfClass:[NSNull class]]) {
        self.month = [month integerValue];
    }else {
        self.month = 0;
    }
    
    if (daySting && ![daySting isKindOfClass:[NSNull class]]) {
        self.day = [daySting integerValue];
    }else {
        self.day = -1;
    }
    
    if (genderSting && ![genderSting isKindOfClass:[NSNull class]]) {
        self.gender = genderSting;
    }else {
        self.gender = @"";
    }
    
    if (headIdSting && ![headIdSting isKindOfClass:[NSNull class]]) {
        self.headerID = headIdSting;
    }else {
        self.headerID = @"";
    }
    
    if (nicknameSting && ![nicknameSting isKindOfClass:[NSNull class]]) {
        self.name = nicknameSting;
    }else {
        self.name = @"";
    }
    
    if (signatureSting && ![signatureSting isKindOfClass:[NSNull class]]) {
        self.signature = signatureSting;
    }else {
        self.signature = @"";
    }
    
    if (yearSting && ![yearSting isKindOfClass:[NSNull class]]) {
        self.year = [yearSting integerValue];
    }else {
        self.year = 0;
    }
}

- (NSString *)name {
    if (_name && ![_name isKindOfClass:[NSNull class]]) {
        return _name;
    }else {
        return @"";
    }
}


@end
