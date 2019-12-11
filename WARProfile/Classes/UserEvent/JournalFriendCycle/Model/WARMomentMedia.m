//
//  WARMomentMedia.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMomentMedia.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"
  
static  float MediaMinWidth = 45.0;
static  float MediaMaxWidth = 110.0;
static float MediaMinHeight = 45.0;
static float MediaMaxHeight = 110.0;

@implementation WARMomentMedia

- (instancetype)init{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, imgId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *imgId) {
            @strongify(self);
            self.imageURL = kPhotoUrl(imgId);
            self.originalImgURL = kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, kScreenHeight), imgId);
        }];
        
        [[RACObserve(self, videoId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *videoId) {
            @strongify(self);
            self.videoURL = kVideoUrl(videoId);
        }];
    }
    return self;
}

- (NSString *)imgH {
    float imageHeight = [_imgH doubleValue];
    
    if (imageHeight < MediaMinHeight) {
        return [NSString stringWithFormat:@"%lf", MediaMinHeight];
    }else if (imageHeight >= MediaMinHeight && imageHeight <= 220.0) {
        return _imgH;
    }else {
        return [NSString stringWithFormat:@"%lf", MediaMaxHeight];
    }
}

- (NSString *)imgW {
    float imageWith = [_imgW doubleValue];
    
    if (imageWith < MediaMinWidth) {
        return [NSString stringWithFormat:@"%lf", MediaMinWidth];
    }else if (imageWith >= MediaMinWidth && imageWith <= 220.0) {
        return _imgW;
    }else {
        return [NSString stringWithFormat:@"%lf", MediaMaxWidth];
    }
}

@end
