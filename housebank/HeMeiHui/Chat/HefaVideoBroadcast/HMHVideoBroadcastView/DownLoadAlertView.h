//
//  HMHDownLoadAlertView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/20.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownLoadCancelBtnClick)();

@interface DownLoadAlertView : UIView

/**
 // 创建警告框 并且3秒后自动消失  样式
 居中图片
 下载成功（失败）
 成功或失败描述
 */
-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)titleStr describeStr:(NSString *)describeStr isLoading:(BOOL)isLoading;

-(void)show;

@property (nonatomic, strong) DownLoadCancelBtnClick downLoadCancelBtnClick;


@property(strong,nonatomic) UILabel *titile;
@property(strong,nonatomic) UIActivityIndicatorView *centerImage;


@end
