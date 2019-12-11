//
//  WARUserHometownModel.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import "WARUserProvinceModel.h"

#import "YYModel.h"


@implementation WARUserProvinceModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"citys" : [WARUserCityModel class]};
}




@end


@implementation WARUserCityModel


@end
