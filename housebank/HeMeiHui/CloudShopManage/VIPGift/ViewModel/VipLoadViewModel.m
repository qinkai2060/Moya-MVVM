//
//  VipLoadViewModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipLoadViewModel.h"

@implementation VipLoadViewModel
- (RACSignal *)loadRequest_getUserInfoByLoginNameWithPhone:(NSString *)phone {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"sid":sidStr,
                              @"phone":objectOrEmptyStr(phone)
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/getUserInfoByLoginName"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                   if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"userInfo"]){
                       [subject sendNext:[dataDic objectForKey:@"userInfo"]];
                       [subject sendCompleted];
                   }
            }else{
                NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":@"您输入的手机号码,还不是我们会员哦"}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)loadRequest_getUserDefinWithPhone:(NSString *)phone {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = @{
                              @"sid":sidStr,
                              @"phone":objectOrEmptyStr(phone)
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/saveRecommender"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                [subject sendNext:@"YES"];
                [subject sendCompleted];
            }else{
                NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":[jsonDic objectForKey:@"msg"]}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)loadRequest_VipAlert {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/checkVipQualification"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if ([dataDic.allKeys containsObject:@"unGetVipLevel"]) {
                     NSNumber * unGetVipLevel = [dataDic objectForKey:@"unGetVipLevel"];
                    if ([unGetVipLevel intValue] >1) {
                        NSString * alertString;
                        if ([unGetVipLevel isEqualToNumber:@2]) {
                            alertString = @"银卡会员";
                        }else if ([unGetVipLevel isEqualToNumber:@3]){
                             alertString = @"铂金会员";
                        }else if ([unGetVipLevel isEqualToNumber:@4]){
                            alertString = @"钻石会员";
                        }
                        [subject sendNext:[RACTuple tupleWithObjects:unGetVipLevel,alertString, nil]];
                    }
                }
            }else{
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}
@end
