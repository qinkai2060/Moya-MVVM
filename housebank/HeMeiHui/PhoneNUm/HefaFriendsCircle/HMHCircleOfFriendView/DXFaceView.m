/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXFaceView.h"
#import "ChatConfiguration.h"

@interface DXFaceView ()
{
    //FacialView *_facialView;
    EmotionsView *_emotionView;
}

@end

@implementation DXFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        _emotionView = [[EmotionsView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 176)];
//        _emotionView.delegate = self;
//        [self addSubview:_emotionView];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(self.frame.size.width-60, CGRectGetMaxY(_emotionView.frame), 60, 40);
//        sendBtn.frame = CGRectMake(self.frame.size.width-60,0, 60, 40);
        [sendBtn setBackgroundColor:[ChatConfiguration shared].mainColor];
        [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////        [[sendBtn layer] setShadowOffset:CGSizeMake(-1, 0)];
////        [[sendBtn layer] setShadowOpacity:0.5];
////        [[sendBtn layer] setShadowColor:[UIColor blackColor].CGColor];
        [sendBtn addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
        
//        [self addSubview:sendBtn];
    }
    return self;
}

#pragma mark - FacialViewDelegate
- (void)emotionsView:(EmotionsView *)emotionsVIew didClickEmotion:(NSString *)string
{
    if (_delegate) {
        [_delegate selectedFacialView:string isDelete:NO];
    }
}

- (void)emotionsViewDidDeleteEmotion:(EmotionsView *)emotionsVIew
{
    if (_delegate) {
        [_delegate selectedFacialView:nil isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
