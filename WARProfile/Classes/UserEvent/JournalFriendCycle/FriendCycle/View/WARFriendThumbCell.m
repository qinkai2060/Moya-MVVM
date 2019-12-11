//
//  WARFriendThumbCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import "WARFriendThumbCell.h"
#import "MLLinkLabel.h"
#import "WARMacros.h"
#import "WARThumbModel.h"
#import "WARDBContactModel.h"
#import "UIImage+WARBundleImage.h"
#import "WARFriendMomentLayout.h"

#define TimeLineCellHighlightedColor HEXCOLOR(0x576B95)

@interface WARFriendThumbCell()<MLLinkLabelDelegate>

@property (nonatomic, strong) UIView *likeView;
@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) UIButton *extendButton;

@end

@implementation WARFriendThumbCell

#pragma mark - System

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.likeView];
    [self.likeView addSubview:self.likeLabel];
    [self.likeView addSubview:self.likeLableBottomLine];
//    [self addSubview:self.extendButton];
}

#pragma mark - Event Response

- (void)extendAction:(UIButton *)button {
    button.selected = !button.selected;
    BOOL selected = button.selected;
    
    
    if ([self.delegate respondsToSelector:@selector(friendThumbCell:didOpen:)]) {
        [self.delegate friendThumbCell:self didOpen:selected];
    }
}

#pragma mark - Delegate

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    NDLog(@"%@", link.linkValue);
    if ([self.delegate respondsToSelector:@selector(friendThumbCell:didThumber:)]) {
        [self.delegate friendThumbCell:self didThumber:link.linkValue];
    }
}

#pragma mark - Private

#pragma mark - Public

#pragma mark - Setter And Getter

- (void)setThumbModel:(WARThumbModel *)thumbModel {
    _thumbModel = thumbModel;
    
    self.likeView.frame = thumbModel.friendDetailThumbLayout.likeViewFrame;
    self.likeLabel.attributedText = thumbModel.thumbUsersAttributedContent;
    self.likeLabel.frame = thumbModel.friendDetailThumbLayout.likeLabelFrame;
    self.likeLableBottomLine.frame = thumbModel.friendDetailThumbLayout.likeLableBottomLineFrame;
//    self.extendButton.frame = thumbModel.journalThumbLayout.extendLikeFrame;
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
        _likeLableBottomLine.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _likeLableBottomLine;
}

- (UIView *)likeView {
    if (!_likeView) {
        _likeView = [[UIView alloc] init];
    }
    return _likeView;
}

//- (UIButton *)extendButton {
//    if (!_extendButton) {
//        UIImage *closeImage = [UIImage war_imageName:@"chat_arrowx" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        UIImage *openImage = [UIImage war_imageName:@"chat_arrows" curClass:[self class] curBundle:@"WARProfile.bundle"];
//
//        _extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _extendButton.adjustsImageWhenHighlighted = NO;
//        _extendButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_extendButton setImage:openImage forState:UIControlStateNormal];
//        [_extendButton setImage:closeImage forState:UIControlStateSelected];
//        //        _extendButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        _extendButton.backgroundColor = [UIColor clearColor];
//        [_extendButton addTarget:self action:@selector(extendAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _extendButton;
//}

@end
