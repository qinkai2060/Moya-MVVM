//
//  WARBaseUserDiaryViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/23.
//

#import "WARBaseUserDiaryViewController.h"

@interface WARBaseUserDiaryViewController ()

@property (nonatomic, assign) BOOL isMine;

@end

@implementation WARBaseUserDiaryViewController

#pragma mark - System

- (instancetype)initWithType:(BOOL)isMine{
    if (self = [super init]) {
        self.isMine = isMine;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - public

-(void)dl_refresh{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dl_UserDiarviewControllerDidFinishRefreshing:)]) {
                [self.delegate dl_UserDiarviewControllerDidFinishRefreshing:self];
                self.isRefreshing = NO;
            }
        });
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

@end
