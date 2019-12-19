//
//  LocationManager.m
//  HeMeiHui
//
//  Created by 任为 on 2018/1/2.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager
static LocationManager *_instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
/**
 初始化位置管理器
 */
-(void)initializeLocationService {
    // 初始化定位管理器
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
        // 设置代理
        _locationManager.delegate = self;
        // 设置定位精确度到米
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
}
- (void)start{
    
    if (_locationManager) {
        [_locationManager startUpdatingLocation];
    }
}
- (void)stop{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stop];

    NSDictionary *location = @{
                               @"lng":@"0",
                               @"lat": @"0",
                               @"type":@"gcj02",
                               @"state":@"failure"
                               };
    NSString *jsonDicStr = [location modelToJSONString];
    self.location(jsonDicStr);
}
- (void)getlocationInfo:(location)locationBlock{
    
    self.location = locationBlock;
}
/**
 定位管理器回调方法
 
 @param manager 管理器
 @param locations 位置信息
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%lu",(unsigned long)locations.count);
    
    //    CLLocation * location = locations.lastObject;
    CLLocation * location = [locations objectAtIndex:0];
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    self.latitude = [[NSNumber numberWithDouble:latitude] stringValue];
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    self.longitude =[[NSNumber numberWithDouble:longitude] stringValue];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (self.longitude&&self.latitude) {
        [self stop];
        [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (! error) {
                if ([placemarks count] > 0) {
                    CLPlacemark *placemark = [placemarks firstObject];
                    
                    // 获取城市
                    NSString *city = placemark.locality.length == 0 ?@"":placemark.locality;
                    
                    NSDictionary *location = @{
                                               //                                   @"lng":self.longitude,
                                               //                                   @"lat": self.latitude,
                                               @"lng":@(longitude),
                                               @"lat": @(latitude),
                                               @"type":@"gcj02",
                                               @"state":@"success",
                                               @"city":city
                                               };
                    NSString *jsonDicStr = [location modelToJSONString];
                    
                    if (self.location) {
                        self.location(jsonDicStr);
                    }
                    
                } else if ([placemarks count] == 0) {
                    
                }
            }
            
            
        }];
        
    }
}

/**
 js调用，获取位置信息的方法
 
 @param body js返回的参数：回调的方法名
 */
+(instancetype)shareTools
{
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
@end
