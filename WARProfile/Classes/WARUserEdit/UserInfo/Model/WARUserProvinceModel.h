//
//  WARUserHometownModel.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import <Foundation/Foundation.h>

@interface WARUserProvinceModel : NSObject

@property (nonatomic, copy)NSString *provinceCode;
@property (nonatomic, copy)NSString *provinceName;
@property (nonatomic, copy)NSString *provincePinyin;
@property (nonatomic, copy)NSArray *citys;




@end

@interface WARUserCityModel : NSObject

@property (nonatomic, copy)NSString *cityCode;
@property (nonatomic, copy)NSString *cityName;
@property (nonatomic, copy)NSString *cityPinyin;


@end

