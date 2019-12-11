//
//  WARLightPlayVideoCell.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/6/28.
//

#import "WARLightPlayVideoCell.h"
#import "WARRecommendVideo.h"
#import "WARLightPlayVideoCellLayout.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "WARLayoutButton.h"
#import "UIImage+WARBundleImage.h"

@interface WARLightPlayVideoCell()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) WARLayoutButton *likeBtn;
@property (nonatomic, strong) WARLayoutButton *commentBtn;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *fullMaskView;
/** delegate */
@property (nonatomic, weak) id<WARLightPlayVideoCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation WARLightPlayVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARLightPlayVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARLightPlayVideoCell"];
    if (!cell) {
        cell = [[[WARLightPlayVideoCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARLightPlayVideoCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.fullMaskView];
        self.contentView.backgroundColor = [UIColor blackColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
 

- (void)setLayout:(WARLightPlayVideoCellLayout *)layout {
    _layout = layout;
    
    WARRecommendVideo *video = layout.video;
    //set data
    NSString *commentString = [[NSString stringWithFormat:@"%ld",video.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.commentCount];
    NSString *likeString = [[NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount];
    NSURL *coverUrl = kVideoCoverUrl(video.url);
    [self.coverImageView sd_setImageWithURL:coverUrl placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.userImageView sd_setImageWithURL:kOriginMediaUrl(video.account.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLabel.text = video.account.friendName;
    self.titleLabel.text = video.desc;
    [self.commentBtn setTitle:commentString forState:UIControlStateNormal];
    [self.likeBtn setTitle:likeString forState:UIControlStateNormal];
    
    //layout
    self.coverImageView.frame = layout.coverImageViewFrame;
    self.playBtn.frame = layout.playBtnFrame;
    self.titleLabel.frame = layout.titleLabelFrame;
    self.userImageView.frame = layout.userImageViewFrame;
    self.nameLabel.frame = layout.nameLabelFrame;
    self.commentBtn.frame = layout.commentBtnFrame;
    self.likeBtn.frame = layout.likeBtnFrame;
    self.fullMaskView.frame = layout.maskViewRect;
    
}

- (void)setDelegate:(id<WARLightPlayVideoCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playTheVideoAtIndexPath:)]) {
        [self.delegate playTheVideoAtIndexPath:self.indexPath];
    }
}

- (void)likeClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lightPlayVideoCell:didPraiseAtIndexPath:)]) {
        [self.delegate lightPlayVideoCell:self didPraiseAtIndexPath:self.indexPath];
    }
}

- (void)commentClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lightPlayVideoCell:didCommentAtIndexPath:)]) {
        [self.delegate lightPlayVideoCell:self didCommentAtIndexPath:self.indexPath];
    }
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
//    self.titleLabel.textColor = [UIColor blackColor];
//    self.nameLabel.textColor = [UIColor blackColor];
//    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)showMaskView {
    [UIView animateWithDuration:0.25 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.25 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.86];
    }
    return _fullMaskView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.userInteractionEnabled = YES;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _nameLabel;
}

- (WARLayoutButton *)likeBtn {
    if (!_likeBtn) {
        UIImage *image = [UIImage war_imageName:@"great_click12" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _likeBtn = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.midSpacing = 3;
        _likeBtn.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _likeBtn.imageSize = CGSizeMake(17, 17);
        _likeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_likeBtn setImage:image forState:UIControlStateNormal];
    }
    return _likeBtn;
}


- (WARLayoutButton *)commentBtn {
    if (!_commentBtn) {
        UIImage *image = [UIImage war_imageName:@"wechat_messag" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _commentBtn = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.midSpacing = 3;
        _commentBtn.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _commentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _commentBtn.imageSize = CGSizeMake(17, 17);
        [_commentBtn setImage:image forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        UIImage *image = [UIImage war_imageName:@"release_home_vide_play" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:image forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

@end
