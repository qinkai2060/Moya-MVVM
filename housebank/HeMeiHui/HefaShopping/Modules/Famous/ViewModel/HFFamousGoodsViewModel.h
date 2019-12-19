//
//  HFFamousGoodsViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFFamousGoodsViewModel : HFViewModel
/**
 数据请求URL
 */
@property(nonatomic,copy) NSString *requstPrams;

/**
 数据请求URL
 */
@property(nonatomic,copy) NSString *requstURL;
/**
 数据请求
 */
@property(nonatomic,strong) RACCommand *dataCommand;

/**
 数据接收发送
 */
@property(nonatomic,strong) RACSubject *dataSendSubjc;
/**
 tou数据请求
 */
@property(nonatomic,strong) RACCommand *headerdataCommand;
/**
  tou数据接收发送
 */
@property(nonatomic,strong) RACSubject *headerdataSendSubjc;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,strong) RACSubject *didSelectSubjc;

/**
 分享数据请求
 */
@property(nonatomic,strong) RACCommand *shareCommand;
/**
 分享接收
 */
@property(nonatomic,strong) RACSubject *shareSubjc;
/**
 分享接收
 */
@property(nonatomic,strong) RACSubject *didBannerSubjc;

@property(nonatomic,copy) NSString *pageTag;
@end

NS_ASSUME_NONNULL_END
