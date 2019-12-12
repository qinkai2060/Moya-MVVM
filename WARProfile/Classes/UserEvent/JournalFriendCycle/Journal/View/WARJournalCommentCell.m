//
//  WARFriendCommentCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARJournalCommentCell.h"
#import "WARTweetVoiceView.h"
#import "WARCommentCollectionViewCell.h"
#import "YYLabel.h"
#import "WARFriendCommentVoiceView.h"
#import "WARFriendCommentMediaView.h"
#import "WARCommentsTool.h"
#import "WARMoment.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

@interface WARJournalCommentCell()

@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIImageView* commentIconView;
@property (nonatomic, strong) UIImageView* userIconView;
@property (nonatomic, strong) WARFriendCommentMediaView* mediaView;
@property (nonatomic, strong) YYLabel* textContentLabel;
@property (nonatomic, strong) YYLabel* nameLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) WARFriendCommentVoiceView* voiceView;

@end

@implementation WARJournalCommentCell
 
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.containerView];
        
        [self.containerView addSubview:self.commentIconView];
        [self.containerView addSubview:self.userIconView];
        
        [self.containerView addSubview:self.nameLabel];
        [self.containerView addSubview:self.timeLabel];
        [self.containerView addSubview:self.textContentLabel];
        [self.containerView addSubview:self.mediaView];
        [self.containerView addSubview:self.voiceView];
    }
    return self;
}

- (void)hideCommentIcon:(BOOL)hide {
    self.commentIconView.hidden = hide;
}

- (void)setCommentLayout:(WARFriendCommentLayout *)commentLayout {
    _commentLayout = commentLayout;
    
    WARFriendComment *comment = commentLayout.comment;
    
    self.containerView.frame = commentLayout.containerViewF;
    
    self.commentIconView.frame = commentLayout.commentIconF;
    self.nameLabel.frame = commentLayout.nameLabelF;
    self.timeLabel.frame = commentLayout.timeLableF;
    self.textContentLabel.frame = commentLayout.contentLabelF;
    self.voiceView.frame = commentLayout.playAudioBtnF;
    self.mediaView.frame = commentLayout.collectionViewF;
    self.userIconView.frame = commentLayout.userIconF;
    
    [self.userIconView sd_setImageWithURL:comment.commentorInfo.headUrl placeholderImage:[WARUIHelper war_defaultUserIcon]];
    
    NSString* nameTitle = comment.nameTitle;
    NSString* contentTitle = comment.contentTitle;
    self.textContentLabel.textLayout = commentLayout.contentTextLayout;
    self.textContentLabel.hidden = kStringIsEmpty(contentTitle);
    self.nameLabel.textLayout = commentLayout.nameTextLayout;
    self.nameLabel.hidden = kStringIsEmpty(nameTitle);
    
    self.timeLabel.text = [comment formatCommentTime];
    
    self.mediaView.layout = commentLayout;
    
    if (!kObjectIsEmpty(comment.commentVoiceInfo)) {
        self.voiceView.hidden = NO;
        self.voiceView.voice = comment.commentVoiceInfo;
    }else{
        self.voiceView.hidden = YES;
    } 
}

#pragma mark - event

- (void)didUserHeader:(UIGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(tapIconWithAccountId:)]) {
        [self.delegate tapIconWithAccountId:self.commentLayout.comment.commentorInfo.accountId];
    }
}

#pragma mark - getter

- (YYLabel *)textContentLabel{
    if (!_textContentLabel) {
        _textContentLabel = [[YYLabel alloc] init];
        _textContentLabel.numberOfLines = 0;
//        _textContentLabel.left = 8 + CommentPadding*2;
//        _textContentLabel.width = CommentReplyMiddleContentW;
        _textContentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _textContentLabel.displaysAsynchronously = YES;
        _textContentLabel.ignoreCommonProperties = YES;
        _textContentLabel.fadeOnAsynchronouslyDisplay = NO;
        _textContentLabel.fadeOnHighlight = NO;
        _textContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        __weak typeof(self) weakSelf = self;
        _textContentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [strongSelf.delegate cell:strongSelf didClickInLabel:(YYLabel *)containerView textRange:range];
            }
        };
    }
    return _textContentLabel;
}

- (YYLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _nameLabel.displaysAsynchronously = YES;
        _nameLabel.ignoreCommonProperties = YES;
        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
        _nameLabel.fadeOnHighlight = NO;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        __weak typeof(self) weakSelf = self;
        _nameLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [strongSelf.delegate cell:strongSelf didClickInLabel:(YYLabel *)containerView textRange:range];
            }
        };
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textColor = HEXCOLOR(0x737373);
    }
    return _timeLabel;
}

- (WARFriendCommentMediaView *)mediaView{
    if (!_mediaView) {
        _mediaView = [[WARFriendCommentMediaView alloc] init];
        __weak typeof(self) weakSelf = self;
        _mediaView.showPhotoBrower = ^(NSArray *photos, NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(showPhotoBrower:currentIndex:)]) {
                [strongSelf.delegate showPhotoBrower:photos currentIndex:index];
            }
        };
        _mediaView.playVideo = ^(WARMomentMedia *video) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(playVideoWithUrl:)]) {
                [strongSelf.delegate playVideoWithUrl:[WARCommentsTool commentsVideoPlayUrl:video.videoId]];
            }
        };
    }
    return _mediaView;
}

- (WARFriendCommentVoiceView *)voiceView{
    if (!_voiceView) {
        _voiceView = [[WARFriendCommentVoiceView alloc] init];
        __weak typeof(self) weakSelf = self;
        _voiceView.audioPlayBlock = ^(WARMomentVoice *audio, UIButton *sender, WARFriendCommentVoiceView *voiceView) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(audioPlay:playBtn:voiceView:)]) {
                [strongSelf.delegate audioPlay:audio playBtn:sender voiceView:voiceView];
            }
        };
    }
    return _voiceView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HEXCOLOR(0xF4F4F6);
    }
    return _containerView;
}

- (UIImageView *)commentIconView {
    if (!_commentIconView) {
        UIImage *image = [UIImage war_imageName:@"wechat_message_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _commentIconView = [[UIImageView alloc]init];
        _commentIconView.image = image;
    }
    return _commentIconView;
}

- (UIImageView *)userIconView {
    if (!_userIconView) {
        _userIconView = [[UIImageView alloc]init];
        _userIconView.contentMode = UIViewContentModeScaleAspectFill;
        _userIconView.layer.masksToBounds = YES;
        _userIconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didUserHeader:)];
        [_userIconView addGestureRecognizer:tap];
    }
    return _userIconView;
}

@end
