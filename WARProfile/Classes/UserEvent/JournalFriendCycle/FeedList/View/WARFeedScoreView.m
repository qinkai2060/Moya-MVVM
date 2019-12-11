//
//  WARFeedScoreView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFeedScoreView.h"
#import "UIImage+WARBundleImage.h"

@interface WARFeedScoreView()

/** startImage1 */
@property (nonatomic, strong) UIImageView *startImage1;
/** startImage2 */
@property (nonatomic, strong) UIImageView *startImage2;
/** startImage3 */
@property (nonatomic, strong) UIImageView *startImage3;
/** startImage4 */
@property (nonatomic, strong) UIImageView *startImage4;
/** startImage5 */
@property (nonatomic, strong) UIImageView *startImage5;

@end

@implementation WARFeedScoreView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.startImage1];
    [self addSubview:self.startImage2];
    [self addSubview:self.startImage3];
    [self addSubview:self.startImage4];
    [self addSubview:self.startImage5];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Public

- (void)setScore:(CGFloat)score {
    UIImage *star = [UIImage war_imageName:@"publish_star_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
    UIImage *halfStar = [UIImage war_imageName:@"publish_star_half_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
    UIImage *noStar = [UIImage war_imageName:@"publish_star_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
    
    if (score <= 0) {
        self.startImage1.image = noStar;
        self.startImage2.image = noStar;
        self.startImage3.image = noStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 0 && score <= 0.5) {
        self.startImage1.image = halfStar;
        self.startImage2.image = noStar;
        self.startImage3.image = noStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 0.5 && score <= 1) {
        self.startImage1.image = star;
        self.startImage2.image = noStar;
        self.startImage3.image = noStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 1 && score <= 1.5) {
        self.startImage1.image = star;
        self.startImage2.image = halfStar;
        self.startImage3.image = noStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 1.5 && score <= 2) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = noStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 2 && score <= 2.5) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = halfStar;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 2.5 && score <= 3) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = noStar;
        self.startImage5.image = noStar;
    } else if (score > 3 && score <= 3.5) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = halfStar;
        self.startImage5.image = noStar;
    } else if (score > 3.5 && score <= 4) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = star;
        self.startImage5.image = noStar;
    } else if (score > 4 && score <= 4.5) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = star;
        self.startImage5.image = halfStar;
    } else if (score > 4.5 && score <= 5) {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = star;
        self.startImage5.image = star;
    } else {
        self.startImage1.image = star;
        self.startImage2.image = star;
        self.startImage3.image = star;
        self.startImage4.image = star;
        self.startImage5.image = star;
    }
    
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (UIImageView *)startImage1 {
    if (!_startImage1) {
        _startImage1 = [[UIImageView alloc] init];
        _startImage1.frame = CGRectMake(0, 0, 15, 15);
        _startImage1.contentMode = UIViewContentModeScaleToFill;
    }
    return _startImage1;
}
- (UIImageView *)startImage2 {
    if (!_startImage2) {
        _startImage2 = [[UIImageView alloc] init];
        _startImage2.frame = CGRectMake(15 + 2, 0, 15, 15);
        _startImage2.contentMode = UIViewContentModeScaleToFill;
    }
    return _startImage2;
}
- (UIImageView *)startImage3 {
    if (!_startImage3) {
        _startImage3 = [[UIImageView alloc] init];
        _startImage3.frame = CGRectMake((15 + 2) * 2, 0, 15, 15);
        _startImage3.contentMode = UIViewContentModeScaleToFill;
    }
    return _startImage3;
}
- (UIImageView *)startImage4 {
    if (!_startImage4) {
        _startImage4 = [[UIImageView alloc] init];
        _startImage4.frame = CGRectMake((15 + 2) * 3, 0, 15, 15);
        _startImage4.contentMode = UIViewContentModeScaleToFill;
    }
    return _startImage4;
}
- (UIImageView *)startImage5 {
    if (!_startImage5) {
        _startImage5 = [[UIImageView alloc] init];
        _startImage5.frame = CGRectMake((15 + 2) * 4, 0, 15, 15);
        _startImage5.contentMode = UIViewContentModeScaleToFill;
    }
    return _startImage5;
}

@end
