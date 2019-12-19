//
//  VideoSendMessageView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/14.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendMessageBlock)(NSString *messageStr);

@interface VideoSendMessageView : UIView

@property (nonatomic, strong) sendMessageBlock sendMessageBlock;
@property (nonatomic, strong) UITextView *sendTextView;

@property (nonatomic, strong) NSString *placeHolderStr;
@property (nonatomic, strong) NSString *titleStr;

@end
