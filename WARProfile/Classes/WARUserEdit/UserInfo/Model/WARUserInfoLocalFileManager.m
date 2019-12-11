//
//  WARUserInfoLocalFileManager.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import "WARUserInfoLocalFileManager.h"
#import "WARUserProvinceModel.h"
#import "YYModel.h"

@implementation WARUserInfoLocalFileManager


+ (NSArray *)allHometowns{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"hometown.json" ofType:nil inDirectory:@"WARProfile.bundle"];
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    
    NSError* error = nil;
    id dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *arr = [NSArray yy_modelArrayWithClass:[WARUserProvinceModel class] json:dict[@"provinces"]];
    return arr;
}


+ (NSArray *)allIndustries{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"industry_propertyList" ofType:@"plist" inDirectory:@"WARProfile.bundle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr;
}

+ (NSArray *)allJobs{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"work_propertyList" ofType:@"plist" inDirectory:@"WARProfile.bundle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr;
}

+ (NSArray *)allFoods{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"food_propertyList" ofType:@"plist" inDirectory:@"WARProfile.bundle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr;
}

+ (NSArray *)allSports{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"sports_propertyList" ofType:@"plist" inDirectory:@"WARProfile.bundle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr;
}

+ (NSArray *)allTravels{
    NSBundle* curBundle = [NSBundle bundleForClass:self];
    NSString* path = [curBundle pathForResource:@"travel_propertyList" ofType:@"plist" inDirectory:@"WARProfile.bundle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr;
    
}



@end
