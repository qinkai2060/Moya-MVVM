//
//  PopAppointViewControllerModel.h
//  HeMeiHui
//
//  Created by 任为 on 2017/10/11.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 naviBg = "#ffb100";
 openType = 1;
 showNavi = 1;
 title = "\U5408\U53d1\U57f9\U8bad";
 url = "./html/house/consultation/university.html.*";
 */
@interface PopAppointViewControllerModel : NSObject
@property (nonatomic, strong)NSString *naviBg;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *pageTag;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSNumber *openType;
@property (nonatomic, strong)NSNumber *pageBackType;
@property (nonatomic, strong)NSNumber *pageLaunchMode;
@property (nonatomic, assign)BOOL showNavi;
@property (nonatomic, assign)BOOL naviMask;
@property (nonatomic, assign)CGFloat naviMaskHeight;
@property (nonatomic, strong)NSString *closePageAfterLaunch;
@property (nonatomic, strong)NSString *refreshPageAfterLaunch;

@end
