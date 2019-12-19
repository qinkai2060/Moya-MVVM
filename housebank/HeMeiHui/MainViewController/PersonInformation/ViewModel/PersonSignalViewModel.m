//
//  PersonSignalViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonSignalViewModel.h"
#import "PersonInfoModel.h"
#import "PersonBaseInfoModel.h"

@implementation PersonSignalViewModel
- (RACSignal *)getRequestPersonInfo {
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary * params = @{
                              @"sid":sid
                              };
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/userBaseInfo"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            NSLog(@"%@",jsonDic);
            NSDictionary * brokerInfo = [jsonDic objectForKey:@"brokerInfo"];
            NSDictionary * brokerBaseInfo = [jsonDic objectForKey:@"brokerBaseInfo"];
            PersonInfoModel * personModel = [PersonInfoModel modelWithDictionary:brokerInfo];
         
            PersonBaseInfoModel * baseModel = [PersonBaseInfoModel modelWithDictionary:brokerBaseInfo];
            [subject sendNext:[RACTuple tupleWithObjects:personModel,baseModel, nil]];
            [subject sendCompleted];
            
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return  subject;
}

- (RACSignal *)changePersonIndoWithParams:(NSDictionary*)params{
    
    RACSubject * subject = [RACSubject subject];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/userinfo/update"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            [subject sendNext:jsonDic];
            [subject sendCompleted];
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return  subject;
}

- (RACSignal *)getIphoneToSendWithNumber:(NSString *)phone areacode:(NSString *)areacode {
    
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary * params = @{
                              @"sid":sid,
                              @"phone":objectOrEmptyStr(phone),
                              @"areacode":@"+86"
                              };
    RACSubject * subject = [RACSubject subject];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.sms/update-phone-msg/send"];
    if (getUrlStr) {
        getUrlStr = getUrlStr;
    }
    [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            [subject sendNext:jsonDic];
            [subject sendCompleted];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return  subject;
}

- (RACSignal *)sendPostUSerHeadImage {
    
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary * params = @{
                              @"d":@"1559100012360",
                              @"save-key":@"/user/1559103612/{random}{.suffix}",
                              @"x-gmkerl-rotate":@"auto",
                              @"return-url":@"",
                              @"sid":sid
                              };
    RACSubject * subject = [RACSubject subject];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./register"]; 
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            [subject sendNext:jsonDic];
            [subject sendCompleted];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return subject;
}

@end
