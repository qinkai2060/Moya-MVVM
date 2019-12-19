//
//  LocationManager.h
//  HeMeiHui
//
//  Created by 任为 on 2018/1/2.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^location)(NSString*);
@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
}
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)location location;


-(void)initializeLocationService;
-(void)start;
-(void)stop;

- (void)getlocationInfo:(location)locationBlock;
+(instancetype)shareTools;
@end
