//
//  ViewController.m
//  视频Demo
//
//  Created by 秦恺 on 16/10/14.
//  Copyright © 2016年 秦恺. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()
  @property (strong, nonatomic) AVPlayer *avPlayer;
//@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    
    //视频播放的url
    NSURL *playerURL = [NSURL URLWithString:playString];
    
    //初始化
    self.playerView = [[AVPlayerViewController alloc]init];
    
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:playerURL];
    
    //通过AVPlayerItem创建AVPlayer
    self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    [self.view.layer addSublayer:layer];
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.playerView.player = self.avPlayer
    ;
    
    //关闭AVPlayerViewController内部的约束
    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
    
//    self.playerView = [[AVPlayerViewController alloc]init];
//    
//    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
//    self.avPlayer  = [[AVPlayer alloc] initWithPlayerItem:playItem];
//    
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
//    
//    playerLayer.videoGravity = AVLayerVideoGravityResize;
//    
//    playerLayer.frame = self.view.bounds;
//    
//    
//    
//    [self.view.layer addSublayer:playerLayer];
//    
//    self.playerView.player = self.avPlayer;
//    
//    //关闭AVPlayerViewController内部的约束
//    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
//    
//    [self showViewController:self.playerView sender:nil];
    
    //[player play];
   
    
//    //这个链接是M3U8的，你看到此博客的时候此链接可能已经失效，请自行找链接测试
//    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://v.qq.com/x/page/o0337jpmnc0.html?start=26"]];
//    //初始化AVPlayer
//    self.player = [[AVPlayer alloc] initWithPlayerItem:playItem];
//    //设置AVPlayer关联
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    //设置视频模式
//    playerLayer.videoGravity = AVLayerVideoGravityResize;
//    playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 9.0 / 16.0);
//    //创建一个UIView与AVPlayerLayer关联
//    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(playerLayer.frame), CGRectGetHeight(playerLayer.frame))];
//    playerView.backgroundColor = [UIColor blackColor];
//    
//    [playerView.layer addSublayer:playerLayer];
//    
//    [self.view addSubview:playerView];
//    //开始播放(请在真机上运行)
//    [self.player play];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:self.playerView sender:nil];
    
    NSLog(@"1212");
    //[self showViewController:self sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
