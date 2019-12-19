//
//  HFLoginViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLoginViewModel.h"
#import "HFLoginRegModel.h"
@implementation HFLoginViewModel
- (void)hh_initialize {
    if ([HFUserDataTools loginAreacode].length > 0) {
       self.countryCode = [HFUserDataTools loginAreacode];
    }else {
        self.countryCode  = @"86";
    }
    if ([HFUserDataTools codeValue].length > 0) {
        self.countryStr = [HFUserDataTools codeValue];
    }else {
        self.countryStr  = @"中国 (+86)";
    }
    
    self.regcountryCode = @"86";
    self.findcountryCode = @"86";
    [[NSUserDefaults standardUserDefaults] setObject:self.countryCode forKey:@"loginAreacode"];
    [[NSUserDefaults standardUserDefaults] setObject:self.countryStr forKey:@"codeValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    @weakify(self)
    self.validSigal = [[RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, passWord)] reduce:^id _Nonnull(NSString *username,NSString *password){
        return @(username.length >0&&password.length >0);
        
    }] distinctUntilChanged];
    self.codevalidSigal = [[RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, code)] reduce:^id _Nonnull(NSString *username,NSString *code){
        return @(username.length >0&&code.length >0);
        
    }] distinctUntilChanged];
    self.regValidSigal = [[RACSignal combineLatest:@[RACObserve(self, regPhone),RACObserve(self, regCode),RACObserve(self, regPassWord)] reduce:^id _Nonnull(NSString *username,NSString *code,NSString *password){
        return @(username.length >0&&code.length >0&&password.length>0);
    }] distinctUntilChanged];
    self.findValidSigal = [[RACSignal combineLatest:@[RACObserve(self, findPhone),RACObserve(self, findCode),RACObserve(self, findPassWord),RACObserve(self, findSurePassWord)] reduce:^id _Nonnull(NSString *username,NSString *code,NSString *password,NSString *surePassWord){
        return @(username.length >0&&code.length >0&&password.length>0&&surePassWord.length > 0);
        
    }] distinctUntilChanged];
    [self.passWordLoginCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.passWordLoginSubject sendNext:x];
    }];
    [self.quickLoginCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.quickLoginSubject sendNext:x];
    }];
    [self.regCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.regSubject sendNext:x];
    }];
    [self.regsendCodeCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.regsendCodeSubject sendNext:x];
    }];
    [self.findCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.findSubject sendNext:x];
    }];
    [self.findsendCodeCommnd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.findsendCodeSubject sendNext:x];
    }];
}
- (RACCommand *)passWordLoginCommnd {
    if (!_passWordLoginCommnd) {
        _passWordLoginCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./login"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"phone":[HFLoginViewModel phone:self.userName areacode:self.countryCode],@"password":self.passWord,@"areacode":self.countryCode} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _passWordLoginCommnd;
}
- (RACCommand *)quickLoginCommnd {
    if (!_quickLoginCommnd) {
        _quickLoginCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./quickLogin"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"phone":[HFLoginViewModel phone:self.userName areacode:self.countryCode],@"code":self.code,@"areacode":self.countryCode,@"validateCode":self.NECaptchaValidate.length == 0 ? @"":self.NECaptchaValidate,@"tuiId":@"0"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _quickLoginCommnd;
}
- (RACCommand *)regCommnd {
    if (!_regCommnd) {
        _regCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./register"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"mobilephone":[HFLoginViewModel phone:self.regPhone areacode:self.regcountryCode],@"password":self.regPassWord,@"code":self.regCode,@"areacode":self.regcountryCode,@"NECaptchaValidate":self.regNECaptchaValidate.length == 0 ? @"":self.regNECaptchaValidate,@"tuiId":@"0",@"name":@"",@"countryId":@(0),@"regionId":@(0),@"cityId":@(0),@"blockId":@(0),@"nickname":@"",@"gender":@(0),@"shareType":@(0),@"registerSource":@"",@"registerSourceProduct":@"",@"flag":@(0)} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _regCommnd;
}
- (RACCommand *)findCommnd {
    if (!_findCommnd) {
        _findCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./reg/back"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"mobilephone":[HFLoginViewModel phone:self.findPhone areacode:self.findcountryCode],@"password":self.findPassWord,@"confirmPassword":self.findSurePassWord,@"code_input":self.findCode,@"areacode":self.findcountryCode,@"NECaptchaValidate":self.findNECaptchaValidate.length == 0 ? @"":self.findNECaptchaValidate} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseString isEqualToString:@"0"]) {
                        [subscriber sendNext:@"成功"];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:request.error];
                        [subscriber sendCompleted];
                    }
                 
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _findCommnd;
}
- (RACCommand *)findsendCodeCommnd {
    if (!_findsendCodeCommnd) {
        _findsendCodeCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.sms/retrieve-password-msg/send"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }

                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"phone":[HFLoginViewModel phone:self.findPhone areacode:self.findcountryCode],@"NECaptchaValidate":self.findNECaptchaValidate,@"areacode":self.findcountryCode} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _findsendCodeCommnd;
}
- (RACCommand *)regsendCodeCommnd {
    if (!_regsendCodeCommnd) {
        _regsendCodeCommnd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.sms/register-msg/send"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"phone":[HFLoginViewModel phone:self.regPhone areacode:self.regcountryCode],@"NECaptchaValidate":self.regNECaptchaValidate,@"areacode":self.regcountryCode} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
                    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _regsendCodeCommnd;
}
+ (NSString *)phone:(NSString*)phone areacode:(NSString*)areacode {
    if ([areacode isEqualToString:@"86"]) {
        return phone;
    }
    return [NSString stringWithFormat:@"%@ %@",areacode,phone];
}
- (RACCommand *)sendQuickCodeCommand {
    if (!_sendQuickCodeCommand) {
        _sendQuickCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.sms/quick-login-msg/send"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }

                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"phone":[HFLoginViewModel phone:self.userName areacode:self.countryCode],@"NECaptchaValidate":self.NECaptchaValidate,@"areacode":self.countryCode} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
                        HFLoginRegModel *loginModel = [[HFLoginRegModel alloc] init];
                        [loginModel getdata:request.responseJSONObject];
                        [subscriber sendNext:loginModel];
                        [subscriber sendCompleted];
                    }
    
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return nil;
        }];
    }
    return _sendQuickCodeCommand;
}
- (RACSignal *)validSigal {
    if (!_validSigal) {
        _validSigal = [[RACSignal alloc] init];
    }
    return _validSigal;
}
- (RACSubject *)quickLoginSubject {
    if (!_quickLoginSubject) {
        _quickLoginSubject = [[RACSubject alloc] init];
    }
    return _quickLoginSubject;
}
- (RACSubject *)passWordLoginSubject {
    if (!_passWordLoginSubject) {
        _passWordLoginSubject = [[RACSubject alloc] init];
    }
    return _passWordLoginSubject;
}
- (RACSubject *)findPassWordSubject {
    if (!_findPassWordSubject) {
        _findPassWordSubject = [[RACSubject alloc] init];
    }
    return _findPassWordSubject;
}
- (RACSubject *)countryCodeCloseSubject {
    if (!_countryCodeCloseSubject) {
        _countryCodeCloseSubject = [[RACSubject alloc] init];
    }
    return _countryCodeCloseSubject;
}
- (RACSubject *)openCountryCodeSubject {
    if (!_openCountryCodeSubject) {
        _openCountryCodeSubject = [[RACSubject alloc] init];
    }
    return _openCountryCodeSubject;
}
- (RACSubject *)didSelectCountryCodeSubject {
    if (!_didSelectCountryCodeSubject) {
        _didSelectCountryCodeSubject = [[RACSubject alloc] init];
    }
    return _didSelectCountryCodeSubject;
}
- (RACSubject *)regsendCodeSubject {
    if (!_regsendCodeSubject) {
        _regsendCodeSubject = [[RACSubject alloc] init];
    }
    return _regsendCodeSubject;
}
- (RACSubject *)regSuccessPhoneSubject {
    if (!_regSuccessPhoneSubject) {
        _regSuccessPhoneSubject = [[RACSubject alloc] init];
    }
    return _regSuccessPhoneSubject;
}
- (RACSubject *)regSuccessPassWordSubject {
    if (!_regSuccessPassWordSubject) {
        _regSuccessPassWordSubject = [[RACSubject alloc] init];
    }
    return _regSuccessPassWordSubject;
}
- (RACSubject *)findSuccessPhoneSubject {
    if (!_findSuccessPhoneSubject) {
        _findSuccessPhoneSubject = [[RACSubject alloc] init];
    }
    return _findSuccessPhoneSubject;
}
- (RACSubject *)findSuccessPassWordSubject {
    if (!_findSuccessPassWordSubject) {
        _findSuccessPassWordSubject = [[RACSubject alloc] init];
    }
    return _findSuccessPassWordSubject;
}
- (RACSubject *)findSubject {
    if (!_findSubject) {
        _findSubject = [[RACSubject alloc] init];
    }
    return _findSubject;
}
- (RACSubject *)findsendCodeSubject {
    if (!_findsendCodeSubject) {
        _findsendCodeSubject = [[RACSubject alloc] init];
    }
    return _findsendCodeSubject;
}
- (RACSubject *)regSubject {
    if (!_regSubject) {
        _regSubject = [[RACSubject alloc] init];
    }
    return _regSubject;
}
- (void)setUserName:(NSString *)userName {
    _userName = [[userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (void)setRegPhone:(NSString *)regPhone {
    _regPhone = [[regPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (void)setFindPhone:(NSString *)findPhone {
      _findPhone = [[findPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (RACSubject *)memberSubject {
    if (!_memberSubject) {
        _memberSubject = [[RACSubject alloc] init];
        
    }
    return _memberSubject;
}
- (RACSubject *)privacySubject {
    if (!_privacySubject) {
        _privacySubject = [[RACSubject alloc] init];
    }
    return _privacySubject;
}
- (RACSubject *)regmemberSubject {
    if (!_regmemberSubject) {
        _regmemberSubject = [[RACSubject alloc] init];
        
    }
    return _regmemberSubject;
}
- (RACSubject *)regprivacySubject {
    if (!_regprivacySubject) {
        _regprivacySubject = [[RACSubject alloc] init];
    }
    return _regprivacySubject;
}
- (RACSubject *)findmemberSubject {
    if (!_findmemberSubject) {
        _findmemberSubject = [[RACSubject alloc] init];
        
    }
    return _findmemberSubject;
}
- (RACSubject *)findprivacySubject {
    if (!_findprivacySubject) {
        _findprivacySubject = [[RACSubject alloc] init];
    }
    return _findprivacySubject;
}
@end
