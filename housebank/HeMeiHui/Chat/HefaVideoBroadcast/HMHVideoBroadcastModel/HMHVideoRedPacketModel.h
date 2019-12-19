//
//  VideoRedPacketModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/12.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 hasRedPacket = 1;
 interval = 120;
 pageTag = "fy_hongbao_openBalance";
 rpId = 1212;
 vno = 123;
 }
 */

// 红包 Model
@interface HMHVideoRedPacketModel : NSObject
// 视频id
@property (nonatomic, strong) NSString *vno;
// 轮询间隔 （秒）
@property (nonatomic, strong) NSNumber *interval;
// 红包跳转页面
@property (nonatomic, strong) NSString *pageTag;
// 如果返回为false 则停止定时器   ture 就循环定时器
@property (nonatomic, strong) NSNumber *hasRedPacket;
// 如果hasRedPacket为ture 则根据rpId来判断是否显示红包icon >0 则显示  否的话不显示
@property (nonatomic, strong) NSNumber *rpId;

@end
