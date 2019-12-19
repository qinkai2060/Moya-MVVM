//
//  SpGoodBaseViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import "SpDetailShufflingHeadView.h"

// Controllers

// Models

// Views

// Vendors
#import <SDCycleScrollView.h>
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
// Categories

// Others

@interface SpDetailShufflingHeadView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectImageTap;
/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@end

@implementation SpDetailShufflingHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    if (self.dc_height>ScreenW) {
        //秒杀
          _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW) delegate:self placeholderImage:nil];
      
    }else
    {
    //        正常商品
          _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenW) delegate:self placeholderImage:nil];
    }
  
    _cycleScrollView.autoScroll = YES; // 不自动滚动
    _cycleScrollView.currentPageDotColor=[UIColor redColor];
//    if (IS_iPhoneX) {
//          _cycleScrollView.pageControlBottomOffset=40;
//    }else
//    {
         _cycleScrollView.pageControlBottomOffset=20;
//    }
  
    [self addSubview:_cycleScrollView];
    
  
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSMutableArray *picUrlArray=[[NSMutableArray alloc]init];
    NSArray *imgArr = _shufflingArray;
    
    if (imgArr.count > index) {
        self.selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < imgArr.count; i++) {
            [_selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
        }
        
        if (_selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = _selectImageTap;
            pictureVC.picUrlArray = imgArr;
            // 标记点击的是哪一张图片
            pictureVC.touchIndex = index;
            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
            CLPresent *present = [CLPresent sharedCLPresent];
            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
            pictureVC.transitioningDelegate = present;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:pictureVC animated:YES completion:nil];
        }
    }
    NSLog(@"点击了%zd轮播图",index);
}

#pragma mark - Setter Getter Methods
- (void)setShufflingArray:(NSArray *)shufflingArray
{
    _shufflingArray = shufflingArray;
    _cycleScrollView.imageURLStringsGroup = shufflingArray;
}


@end
