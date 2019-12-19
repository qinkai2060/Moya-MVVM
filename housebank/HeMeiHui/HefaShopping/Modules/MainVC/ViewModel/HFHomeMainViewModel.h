//
//  HFHomeMainViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface HFHomeMainViewModel : HFViewModel
@property(nonatomic,strong)RACSubject *moudleSubjc;

@property(nonatomic,strong)RACSubject *moudleRqSubjc;
@property(nonatomic,strong)RACCommand *moudleRqCommand;

@property(nonatomic,strong)RACCommand *shareCommand;
@property(nonatomic,strong)RACSubject *shareSubject;

@property(nonatomic,strong)RACCommand *regCommand;
@property(nonatomic,strong)RACSubject *regSubject;

@property(nonatomic,strong)RACSubject *timeKillSubject;
@property(nonatomic,strong)RACCommand *timeKillCommand;

@property(nonatomic,strong)RACSubject *nativeSwitchSubject;
@property(nonatomic,strong)RACCommand *nativeSwitchCommand;
/**
 偏移值
 */
@property(nonatomic,strong)RACSubject *sendScaleSubjc;
/**
 点击browser
 */
@property(nonatomic,strong)RACSubject *didBrowserSubjc;
/**
 点击Global
 */
@property(nonatomic,strong)RACSubject *didGloabalSubjc;
/**
 点击News
 */
@property(nonatomic,strong)RACSubject *didNewsSubjc;//didNewsMoreSubjc
/**
 点击News更多
 */
@property(nonatomic,strong)RACSubject *didNewsMoreSubjc;
/**
 点击TimeKill
 */
@property(nonatomic,strong)RACSubject *didTimeKillSubjc;
/**
 点击Banner
 */
@property(nonatomic,strong)RACSubject *didBannerSubjc;
/**
 点击Special
 */
@property(nonatomic,strong)RACSubject *didSpecialSubjc;
/**
 点击fashion
 */
@property(nonatomic,strong)RACSubject *didFashionSubjc;
/**
 点击zuber
 */
@property(nonatomic,strong)RACSubject *didZuberSubjc;
/**
 点击ModuleFour
 */
@property(nonatomic,strong)RACSubject *didModuleFourSubjc;
/**
 点击ModuleFive
 */
@property(nonatomic,strong)RACSubject *didModuleFiveSubjc;
/**
 点击ModuleSix
 */
@property(nonatomic,strong)RACSubject *didModuleSixSubjc;

/**
 滚动控制
 */
@property(nonatomic,strong)RACSubject *scrollerControlSubjc;
/**

 加载数据

 */
@property(nonatomic,strong)RACSubject *didFinishLoadData;

@end


NS_ASSUME_NONNULL_END
