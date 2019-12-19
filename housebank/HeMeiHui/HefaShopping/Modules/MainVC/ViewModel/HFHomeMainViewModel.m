//
//  HFHomeMainViewModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeMainViewModel.h"
#import "HFSectionModel.h"
#import "HFDBHandler.h"
#import "HFTimeLimitModel.h"
@implementation HFHomeMainViewModel
- (void)hh_initialize {
    @weakify(self)
    [self.shareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.shareSubject sendNext:x];
    }];
    [self.regCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.regSubject sendNext:x];
    }];
    [self.moudleRqCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.moudleRqSubjc sendNext:x];
    }];
    [self.timeKillCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.timeKillSubject sendNext:x];
    }];
    
    
    
}
- (RACCommand *)shareCommand {
    if (!_shareCommand) {
        _shareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.share-view/webview/share"];
                if (getUrlStr) {
                    getUrlStr = getUrlStr;
                }
                [HFCarRequest requsetUrl:getUrlStr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE",@"pageTag":@"APP_INVITE_PAGE",@"shareId":[HFCarShoppingRequest uid],@"u":[HFCarShoppingRequest uid]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        [subscriber sendNext:[request.responseObject valueForKey:@"data"]];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _shareCommand;
}
- (RACCommand *)regCommand {
    if (!_regCommand) {
        _regCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/shareQrImage"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        [subscriber sendNext:[request.responseObject valueForKey:@"data"]];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _regCommand;
}
- (RACCommand *)timeKillCommand {
    if (!_timeKillCommand) {
        _timeKillCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
              NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/activity/time-limited-spike/home-list"];
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        HFTimeLimitModel *timeModel = [[HFTimeLimitModel alloc] init];
                        timeModel.contenMode = HHFHomeBaseModelTypeTimeLimitKillType;
                        [timeModel getData:[request.responseObject valueForKey:@"data"]];
                        [subscriber sendNext:timeModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _timeKillCommand;
}
- (RACCommand *)nativeSwitchCommand {
    if (!_nativeSwitchCommand) {
        _nativeSwitchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./page/controlAppPageShow"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        if ([[[request.responseObject valueForKey:@"data"] valueForKey:@"result"] isEqualToString:@"0"]) {
                            [subscriber sendNext:@(0)];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendNext:@(1)];
                            [subscriber sendCompleted];
                        }
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    NSLog(@"");
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@(2)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _nativeSwitchCommand;
}
- (RACCommand *)moudleRqCommand {
    if (!_moudleRqCommand) {
        _moudleRqCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./indexApp/selectAppRelease"];
                [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid],@"terminal":@"P_TERMINAL_MOBILE"} success:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if ([request.responseObject isKindOfClass:[NSDictionary class]]&&[[request.responseObject valueForKey:@"state"] intValue] == 1&&[[request.responseObject valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        
                        NSMutableString *responseString = [NSMutableString stringWithString:[[[request.responseObject valueForKey:@"data"] valueForKey:@"result"] valueForKey:@"jsonContent"]];
                        NSData * data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        if ([[dataDic valueForKey:@"AppData"] isKindOfClass:[NSArray class]]) {
                            NSArray * arrayData =  [dataDic valueForKey:@"AppData"];
                            
                            if (arrayData.count > 0) {
                                [HFDBHandler cacheData:[request.responseObject valueForKey:@"data"]];
                                NSLog(@"首页数据%@",[HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO]);
                                [subscriber sendNext: [HFSectionModel jsonSerialize:[dataDic valueForKey:@"AppData"] isVip:NO]];
                                [subscriber sendCompleted];
                            }else {
                                if ([HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"] isVip:NO].count >0) {
                                    [subscriber sendNext:[HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO] ];
                                    [subscriber sendCompleted];
                                }else {
                                    [subscriber sendNext:@(2)];
                                    [subscriber sendCompleted];
                                }
                            }
                        }else {
                            if ([HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO].count >0) {
                                [subscriber sendNext:[HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO] ];
                                [subscriber sendCompleted];
                            }else {
                                [subscriber sendNext:@(2)];
                                [subscriber sendCompleted];
                            }
                        }
                        
                    }else {
                        if ([HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO].count >0) {
                            [subscriber sendNext:[HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO] ];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendNext:@(2)];
                            [subscriber sendCompleted];
                        }
                        
                    }
                } error:^(__kindof YTKBaseRequest * _Nonnull request) {
            
                    if ([HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO].count >0) {
                        [subscriber sendNext:[HFSectionModel jsonSerialize:[[HFDBHandler selectData] valueForKey:@"AppData"]isVip:NO] ];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:@(2)];
                        [subscriber sendCompleted];
                    }
                    
                    
                }];
                
                return nil;
            }];
            
        }];
        
    }
    return _moudleRqCommand;
}
- (RACSubject *)shareSubject {
    if (!_shareSubject) {
        _shareSubject = [[RACSubject alloc] init];
    }
    return _shareSubject;
}
- (RACSubject *)regSubject {
    if (!_regSubject) {
        _regSubject = [[RACSubject alloc] init];
    }
    return _regSubject;
}
- (RACSubject *)moudleSubjc {
    if (!_moudleSubjc) {
        _moudleSubjc = [[RACSubject alloc] init];
    }
    return _moudleSubjc;
}
- (RACSubject *)moudleRqSubjc {
    if (!_moudleRqSubjc) {
        _moudleRqSubjc = [[RACSubject alloc] init];
    }
    return _moudleRqSubjc;
}
- (RACSubject *)timeKillSubject {
    if (!_timeKillSubject) {
        _timeKillSubject = [[RACSubject alloc] init];
    }
    return _timeKillSubject;
}
- (RACSubject *)didBrowserSubjc {
    if (!_didBrowserSubjc) {
        _didBrowserSubjc = [[RACSubject alloc] init];
    }
    return _didBrowserSubjc;
}
- (RACSubject *)didGloabalSubjc {
    if (!_didGloabalSubjc) {
        _didGloabalSubjc = [[RACSubject alloc] init];
    }
    return _didGloabalSubjc;
}
- (RACSubject *)didNewsSubjc {
    if (!_didNewsSubjc) {
        _didNewsSubjc = [[RACSubject alloc] init];
    }
    return _didNewsSubjc;
}
- (RACSubject *)didNewsMoreSubjc {
    if (!_didNewsMoreSubjc) {
        _didNewsMoreSubjc = [[RACSubject alloc] init];
    }
    return _didNewsMoreSubjc;
}
- (RACSubject *)didTimeKillSubjc {
    if (!_didTimeKillSubjc) {
        _didTimeKillSubjc = [[RACSubject alloc] init];
    }
    return _didTimeKillSubjc;
}
- (RACSubject *)didBannerSubjc {
    if (!_didBannerSubjc) {
        _didBannerSubjc = [[RACSubject alloc] init];
    }
    return _didBannerSubjc;
}
//didSpecialSubjc
- (RACSubject *)didSpecialSubjc {
    if (!_didSpecialSubjc) {
        _didSpecialSubjc = [[RACSubject alloc] init];
    }
    return _didSpecialSubjc;
}
//didFashionSubjc
- (RACSubject *)didFashionSubjc {
    if (!_didFashionSubjc) {
        _didFashionSubjc = [[RACSubject alloc] init];
    }
    return _didFashionSubjc;
}
- (RACSubject *)didZuberSubjc {
    if (!_didZuberSubjc) {
        _didZuberSubjc = [[RACSubject alloc] init];
    }
    return _didZuberSubjc;
}
- (RACSubject *)didModuleFourSubjc {
    if (!_didModuleFourSubjc) {
        _didModuleFourSubjc = [[RACSubject alloc] init];
    }
    return _didModuleFourSubjc;
    
}
- (RACSubject *)didModuleFiveSubjc {
    if (!_didModuleFiveSubjc) {
        _didModuleFiveSubjc = [[RACSubject alloc] init];
    }
    return _didModuleFiveSubjc;
    
}
- (RACSubject *)didModuleSixSubjc {
    if (!_didModuleSixSubjc) {
        _didModuleSixSubjc = [[RACSubject alloc] init];
    }
    return _didModuleSixSubjc;
    
}
- (RACSubject *)sendScaleSubjc {
    if (!_sendScaleSubjc) {
        _sendScaleSubjc = [[RACSubject alloc] init];
    }
    return _sendScaleSubjc;
}
- (RACSubject *)scrollerControlSubjc {
    if (!_scrollerControlSubjc) {
        _scrollerControlSubjc = [[RACSubject alloc] init];
    }
    return _scrollerControlSubjc;
}
- (RACSubject *)nativeSwitchSubject {
    if (!_nativeSwitchSubject) {
        _nativeSwitchSubject = [[RACSubject alloc] init];
    }
    return _nativeSwitchSubject;
}
- (RACSubject *)didFinishLoadData {
    if (!_didFinishLoadData) {
        _didFinishLoadData = [[RACSubject alloc] init];
    }
    return _didFinishLoadData;
}

@end
