//
//  EmotionsView.h
//  MCF2
//
//  Created by QianDeng on 16/5/12.
//  Copyright © 2016年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ChatDefine.h"

@protocol EmotionsViewDelegate;
@interface EmotionsView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollEmoView;
@property (nonatomic, strong) NSArray *emotions;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) id<EmotionsViewDelegate> delegate;

@end

@protocol EmotionsViewDelegate <NSObject>
@optional
-(void) emotionsView:(EmotionsView *)emotionsVIew didClickEmotion:(NSString *)string;
-(void) emotionsViewDidDeleteEmotion:(EmotionsView *)emotionsVIew;
@end
