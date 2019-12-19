//
//  HFKefuButton.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFKefuButton.h"
#import "HFIMMessageController.h"
@interface HFKefuButton ()
@property(nonatomic,strong)UIViewController *viewController;
@end
@implementation HFKefuButton
+ (instancetype)kefuBtn:(UIViewController*)VC {
    return [[self alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-71,300,66,66)withViewController:VC];
}
- (instancetype)initWithFrame:(CGRect)frame  withViewController:(UIViewController*)viewController{
    if(self = [super initWithFrame:CGRectMake(SCREEN_WIDTH-71,300,66,66)]) {
        [self initAddEventBtn];
        self.viewController = viewController;
        [self.viewController.view addSubview:self];
    }
    return self;
}

-(void)initAddEventBtn{
    [self setImage:[UIImage imageNamed:@"kefu"]  forState:UIControlStateNormal];
    //   btn.backgroundColor = [UIColor redColor];
    self.tag = 0;
    self.layer.cornerRadius = 8;
//    [self.view addSubview:btn]
    [self addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self addGestureRecognizer:panRcognize];
    
}
- (void)addEvent:(UIButton*)btn {
    HFIMMessageController *vc = [[HFIMMessageController alloc] init];
    vc.title = @"在线客服";
    [vc setUrl:[NSString stringWithFormat:@"http://webchat.7moor.com/wapchat.html?accessId=2c5fe110-b494-11e7-8b49-0d6c5756f804&clientId=%@",[HFUserDataTools getUserUidStr]]];
    //        [vc setUrl:@"http://webchat.7moor.com/wapchat.html?accessId=2c5fe110-b494-11e7-8b49-0d6c5756f804&otherParams={%27nickName%27:%27H12962205%27}&clientId=935648"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBar.hidden=NO;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.viewController.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, SCREEN_HEIGHT / 2.0);
            
            if (recognizer.view.center.x < SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            }else{
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //右上
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.width/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.width/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (self.width>=200) {
                if (stopPoint.y +40>= SCREEN_HEIGHT) {
                    stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.width/2.0-49-40);
                    NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
                }
                if (stopPoint.x - self.width/2.0 <= 0) {
                    stopPoint = CGPointMake(self.width/2.0, stopPoint.y);
                }
                if (stopPoint.x + self.width/2.0 >= SCREEN_WIDTH) {
                    stopPoint = CGPointMake(SCREEN_WIDTH - self.width/2.0, stopPoint.y);
                }
                if (stopPoint.y - self.height/2.0 <= 20) {
                    stopPoint = CGPointMake(stopPoint.x, self.width/2.0);
                }
            }else
            {
                if (stopPoint.y + self.width+40>= SCREEN_HEIGHT) {
                    stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.width/2.0-49-40);
                    NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
                }
                if (stopPoint.x - self.width/2.0 <= 0) {
                    stopPoint = CGPointMake(self.width/2.0, stopPoint.y);
                }
                if (stopPoint.x + self.width/2.0 >= SCREEN_WIDTH) {
                    stopPoint = CGPointMake(SCREEN_WIDTH - self.width/2.0, stopPoint.y);
                }
                if (stopPoint.y - self.width/2.0 <= 0) {
                    stopPoint = CGPointMake(stopPoint.x, self.width/2.0);
                }
            }
           
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.viewController.view];
}
+ (instancetype)showAlertView:(UIViewController*)VC
{
    return [[self alloc] initWithFrame:CGRectMake(0,300,SCREEN_WIDTH,50)withAlertViewController:VC];
}
- (instancetype)initWithFrame:(CGRect)frame  withAlertViewController:(UIViewController*)viewController{
    if(self = [super initWithFrame:CGRectMake(0,300,SCREEN_WIDTH,50)]) {
        [self initAleartBtn];
        self.viewController = viewController;
        [self.viewController.view addSubview:self];
    }
    return self;
}
-(void)initAleartBtn{
    //    [self setImage:[UIImage imageNamed:@"kefu"]  forState:UIControlStateNormal];
    self.backgroundColor = [UIColor redColor];
    self.tag = 0;
    self.layer.cornerRadius = 8;
    //    [self.view addSubview:btn]
    //    [self addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self addGestureRecognizer:panRcognize];
    
}
@end
