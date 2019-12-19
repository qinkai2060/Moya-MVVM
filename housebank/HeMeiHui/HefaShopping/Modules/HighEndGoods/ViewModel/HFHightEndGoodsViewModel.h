//
//  HFHightEndGoodsViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFHightEndGoodsViewModel : HFViewModel

/**
 数据请求
 */
@property(nonatomic,strong) RACCommand *dataCommand;

/**
 数据接收发送
 */
@property(nonatomic,strong) RACSubject *dataSendSubjc;

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

@end

NS_ASSUME_NONNULL_END
