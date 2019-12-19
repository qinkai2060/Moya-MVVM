//
//  STShoppingAddressMainView.m
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STShoppingAddressMainView.h"
#import "LocationManager.h"
#import "STAddressLocationView.h"

@interface STShoppingAddressMainView ()
//<CateorySearchViewDelegate>

@property (nonatomic, strong) STAddressLocationView *locationView;

@end

@implementation STShoppingAddressMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    //
    self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44) isAddOneBtn:NO addBtnImageName:@"" addBtnTitle:@"" searchKeyStr:@"" canEidt:YES placeholderStr:@"" isHaveBack:YES isHaveBottomLine:YES];
    [self addSubview:self.searchView];
    
    __weak typeof(self) weakSelf = self;
    
    LocationManager *locationManager = [LocationManager shareTools];
    [locationManager initializeLocationService];
    [locationManager start];
    [locationManager getlocationInfo:^(NSString *locationStr) {
        //        NSLog(@"%@",locationStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [weakSelf dictionaryWithJsonString:locationStr];
            //在这里处理UI
            [weakSelf reverseGeocodeLatitude:dic[@"lat"] longitude:dic[@"lng"]];
        });
    }];
    
    //
    self.locationView = [[STAddressLocationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.frame.size.width, 41) type:2];
    [self addSubview:self.locationView];
    
    //
    self.topView = [[STAddressTopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.locationView.frame), ScreenW,self.frame.size.height - CGRectGetMaxY(self.locationView.frame))];
    [self addSubview:self.topView];
}

- (void)reverseGeocodeLatitude:(NSString *)latitude longitude:(NSString *)longitude { // 先给一个经纬度
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[latitude longLongValue] longitude:[longitude longLongValue]];
    // 开始逆地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count < 1) {
            // 给的经纬度可能找不到，逆地理编码不成功
            
        } else {
            //  编码成功(找到了具体的位置信息)
            // 输出查询到的所有地标信息
            for (CLPlacemark *placeMark in placemarks) {
//                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@", placeMark.name, placeMark.locality, placeMark.country, placeMark.postalCode);
                
                [self.locationView refreshViewWithAddress:placeMark.locality];
            } // 获取数组中第一个元素的地标信息
//            CLPlacemark *placeMark = placemarks.firstObject;
//            NSLog(@"%@",[placeMark.addressDictionary[@"FormattedAddressLines"] firstObject]);
        }
    }];
}


#pragma mark  json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
