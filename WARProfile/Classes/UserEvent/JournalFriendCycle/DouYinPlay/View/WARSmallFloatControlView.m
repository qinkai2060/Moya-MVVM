//
//  WARSmallFloatControlView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/29.
//

#import "WARSmallFloatControlView.h"
#import "WARMacros.h"
//#import "WARLayoutButton.h"
#import "UIImage+WARBundleImage.h"

#define margin 10

@interface WARSmallFloatControlView()

/** fullScreenButton */
//@property (nonatomic, strong) WARLayoutButton *fullScreenButton;
@end

@implementation WARSmallFloatControlView
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) { 
//        [self addSubview:self.fullScreenButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.fullScreenButton.frame = CGRectMake(self.bounds.size.width - 22, self.bounds.size.height - 22, 22, 22);
}

//- (void)fullScreenAction:(UIButton *)button {
//    if (self.didFullScreenBlock) {
//        self.didFullScreenBlock();
//    }
//}

- (void)setPlayer:(WARPlayerController *)player {
    _player = player;
    self.landScapeControlView.player = player;
    self.portraitControlView.player = player;
}

//- (WARLayoutButton *)fullScreenButton {
//    if (!_fullScreenButton) {
//        UIImage *image = [UIImage war_imageName:@"bigbig" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        _fullScreenButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
//        _fullScreenButton.frame = CGRectMake(self.bounds.size.width - 22, self.bounds.size.height - 22, 22, 22);
//        _fullScreenButton.imageSize = CGSizeMake(16, 16);
//        _fullScreenButton.userInteractionEnabled = YES;
//        _fullScreenButton.backgroundColor = [UIColor redColor];
//        [_fullScreenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_fullScreenButton setImage:image forState:UIControlStateNormal];
//    }
//    return _fullScreenButton;
//}

@end
