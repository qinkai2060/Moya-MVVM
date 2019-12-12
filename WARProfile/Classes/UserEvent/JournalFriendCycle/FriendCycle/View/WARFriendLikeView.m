//
//  WARFriendLikeView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/5.
//

#import "WARFriendLikeView.h"
#import "MLLinkLabel.h"
#import "WARMacros.h"
#import "WARMoment.h"
#import "WARDBContactModel.h"
#import "UIImage+WARBundleImage.h"
#import "UIImage+Tint.h"
#import "WARFriendMomentLayout.h"

#define TimeLineCellHighlightedColor HEXCOLOR(0x576B95)

@interface WARFriendLikeView()<MLLinkLabelDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) UIButton *extendButton;

@end

@implementation WARFriendLikeView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.likeLabel];
    [self addSubview:self.likeLableBottomLine];
    [self addSubview:self.extendButton];
}

#pragma mark - Event Response

- (void)extendAction:(UIButton *)button {
    button.selected = !button.selected;
    BOOL selected = button.selected;
 
    
    if ([self.delegate respondsToSelector:@selector(likeView:didOpen:)]) {
        [self.delegate likeView:self didOpen:selected];
    }
}

#pragma mark - Delegate

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    NDLog(@"%@", link.linkValue);
    if ([self.delegate respondsToSelector:@selector(likeView:didThumber:)]) {
        [self.delegate likeView:self didThumber:link.linkValue];
    }
}

#pragma mark - Private

#pragma mark - Public

#pragma mark - Setter And Getter

- (void)setMoment:(WARMoment *)moment {
     _moment = moment;
    
    self.likeLabel.attributedText = moment.thumbUsersAttributedContent;
    
    self.bgImageView.frame = moment.friendMomentLayout.likeBgImageViewFrame;
    self.likeLabel.frame = moment.friendMomentLayout.likeLabelFrame;
    self.likeLableBottomLine.frame = moment.friendMomentLayout.likeLableBottomLineFrame;
    self.extendButton.frame = moment.friendMomentLayout.extendLikeFrame;
    
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
//        UIImage *image = [UIImage war_imageName:@"LikeCmtBg" curClass:[self class] curBundle:@"WARProfile.bundle"];//[[UIImage war_imageName:@"LikeCmtBg" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:HEXCOLOR(0xF4F4F6)];
//        UIImage *bgImage = [[image stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _bgImageView = [[UIImageView alloc]init];
//        _bgImageView.image = bgImage;
        _bgImageView.backgroundColor = HEXCOLOR(0xF4F4F6);
    }
    return _bgImageView;
}

- (MLLinkLabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [MLLinkLabel new];
        _likeLabel.delegate = self;
        _likeLabel.numberOfLines = 0;
        _likeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : TimeLineCellHighlightedColor};
    }
    return _likeLabel;
}

- (UIView *)likeLableBottomLine {
    if (!_likeLableBottomLine) {
        _likeLableBottomLine = [UIView new];
//        _likeLableBottomLine.backgroundColor = HEXCOLOR(0xDDDEDF);
        
        _likeLableBottomLine.backgroundColor = HEXCOLOR(0xDCDEE6);
        _likeLableBottomLine.alpha = 0.6;
    }
    return _likeLableBottomLine;
}

- (UIButton *)extendButton {
    if (!_extendButton) {
        UIImage *closeImage = [UIImage war_imageName:@"chat_arrowx" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *openImage = [UIImage war_imageName:@"chat_arrows" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _extendButton.adjustsImageWhenHighlighted = NO;
        _extendButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_extendButton setImage:openImage forState:UIControlStateNormal];
        [_extendButton setImage:closeImage forState:UIControlStateSelected];
//        _extendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _extendButton.backgroundColor = [UIColor clearColor];
        [_extendButton addTarget:self action:@selector(extendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extendButton;
}

@end
