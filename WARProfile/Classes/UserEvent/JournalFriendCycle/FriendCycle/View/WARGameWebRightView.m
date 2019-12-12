//
//  WARGameWebRightView.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/24.
//

#import "WARGameWebRightView.h"

#import "WARMacros.h"

#import "UIImage+WARBundleImage.h"

@interface WARGameWebRightView()
/** leftImageView */
@property (nonatomic, strong) UIImageView *leftImageView;
/** rightImageView */
@property (nonatomic, strong) UIImageView *rightImageView;
/** line */
@property (nonatomic, strong) UIView *lineView;
/** leftButton */
@property (nonatomic, strong) UIButton *leftButton;
/** rightButton */
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation WARGameWebRightView

#pragma mark - Initial

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.lineView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightButton];
    
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3].CGColor;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
}

#pragma mark - Event Response

- (void)leftAction:(UIButton *)button {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

- (void)rightAction:(UIButton *)button {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - Delegate

#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.frame =CGRectMake(12, 5.5, 22, 22);
        _leftImageView.image = [UIImage war_imageName:@"more_game" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _leftImageView.layer.masksToBounds = YES;
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.frame =CGRectMake(54, 5.5, 22, 22);
        _rightImageView.image = [UIImage war_imageName:@"close_game" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _rightImageView.layer.masksToBounds = YES;
    }
    return _rightImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.frame = CGRectMake(43.5, 6.5, 0.5, 19);
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 43.5, 32);
        [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}


- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(44, 0, 43.5, 32);
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}



@end
