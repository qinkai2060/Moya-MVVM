//
//  WARJournalThumbCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/13.
//

#import "WARJournalThumbCell.h"
#import "MLLinkLabel.h"
#import "WARMacros.h"
#import "WARThumbModel.h"
#import "WARDBContactModel.h"
#import "UIImage+WARBundleImage.h"
#import "WARFriendMomentLayout.h"
#import "UIImage+Tint.h"

#define TimeLineCellHighlightedColor HEXCOLOR(0x576B95)

@interface WARJournalThumbCell()<MLLinkLabelDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *likeIconView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) UIButton *extendButton;

@end

@implementation WARJournalThumbCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI{ 
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.likeIconView];
    [self.bgImageView addSubview:self.likeLabel];
    [self.bgImageView addSubview:self.likeLableBottomLine];
    [self.bgImageView addSubview:self.extendButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - Event Response

- (void)extendAction:(UIButton *)button {
    button.selected = !button.selected;
    BOOL selected = button.selected;
     
    if ([self.delegate respondsToSelector:@selector(journalThumbCell:didOpenThumber:)]) {
        [self.delegate journalThumbCell:self didOpenThumber:selected];
    }
}

#pragma mark - Delegate

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    NDLog(@"%@", link.linkValue);
    if ([self.delegate respondsToSelector:@selector(journalThumbCell:didThumber:)]) {
        [self.delegate journalThumbCell:self didThumber:link.linkValue];
    }
}

#pragma mark - Private

#pragma mark - Public

- (void)hideBottomLine:(BOOL)hide {
    self.likeLableBottomLine.hidden = hide;
}

#pragma mark - Setter And Getter

- (void)setThumbModel:(WARThumbModel *)thumbModel {
    _thumbModel = thumbModel;
    
    self.likeLabel.attributedText = thumbModel.noIconThumbUsersAttributedContent;
    
    self.bgImageView.frame = thumbModel.journalThumbLayout.likeBgImageViewFrame;
    self.likeIconView.frame = thumbModel.journalThumbLayout.likeIconFrame;
    self.likeLabel.frame = thumbModel.journalThumbLayout.likeLabelFrame;
    self.likeLableBottomLine.frame = thumbModel.journalThumbLayout.likeLableBottomLineFrame;
    self.extendButton.frame = thumbModel.journalThumbLayout.extendLikeFrame;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
//        UIImage *image = [UIImage war_imageName:@"LikeCmtBg" curClass:[self class] curBundle:@"WARProfile.bundle"];//[[UIImage war_imageName:@"LikeCmtBg" curClass:[self class] curBundle:@"WARProfile.bundle"] imageWithTintColor:HEXCOLOR(0xF4F4F6)];
//        UIImage *bgImage = [[image stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _bgImageView = [[UIImageView alloc]init];
//        _bgImageView.image = bgImage;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = HEXCOLOR(0xF4F4F6);
    }
    return _bgImageView;
}

- (UIImageView *)likeIconView {
    if (!_likeIconView) {
        UIImage *image = [UIImage war_imageName:@"great" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _likeIconView = [[UIImageView alloc]init];
        _likeIconView.image = image;
        _likeIconView.backgroundColor = [UIColor clearColor];
    }
    return _likeIconView;
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
        _likeLableBottomLine.backgroundColor = HEXCOLOR(0xDDDEDF);
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
