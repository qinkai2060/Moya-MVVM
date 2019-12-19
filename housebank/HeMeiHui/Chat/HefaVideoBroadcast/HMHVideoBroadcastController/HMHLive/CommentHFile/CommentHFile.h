//
//  CommentHFile.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#ifndef CommentHFile_h
#define CommentHFile_h

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,HMHomeLiveMoreType) {
    
    HMHomeLiveMoreType_Channel = 1,//直播频道
    HMHomeLiveMoreType_Consult = 2,//最新咨询
    HMHomeLiveMoreType_ShortVideo = 3,//短视频
    HMHomeLiveMoreType_Recommend = 4,//编辑推荐
    HMHomeLiveMoreType_Activity = 5//活动精选
};

#define WScale(x)  ((x) * ([UIScreen mainScreen].bounds.size.width) / 375.0)

#define ImageLive(imageName) ([self imageWithImageName:[NSString stringWithFormat:@"%@",imageName]])

#define imageURL(x) ([NSString stringWithFormat:@"%@%@%@",[ManagerTools shareManagerTools].appInfoModel.imageServerUrl,x,@"!PD450"])
#endif /* CommentHFile_h */
