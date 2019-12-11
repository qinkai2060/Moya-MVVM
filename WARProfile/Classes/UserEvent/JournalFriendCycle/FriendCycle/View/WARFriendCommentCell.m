//
//  WARFriendCommentCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentCell.h"
#import "WARTweetVoiceView.h"
#import "WARCommentCollectionViewCell.h"
#import "YYLabel.h"
#import "WARFriendCommentVoiceView.h"
#import "WARFriendCommentMediaView.h"
#import "WARCommentsTool.h"
#import "WARMoment.h"

@interface WARFriendCommentCell()

@property (nonatomic, strong) WARFriendCommentMediaView* mediaView;
@property (nonatomic, strong) YYLabel* textContentLabel;
@property (nonatomic, strong) WARFriendCommentVoiceView* voiceView;

@end

@implementation WARFriendCommentCell
 
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = HEXCOLOR(0xF4F4F6);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textContentLabel];
        [self.contentView addSubview:self.mediaView];
        [self.contentView addSubview:self.voiceView];
    }
    return self;
}

- (void)setCommentLayout:(WARFriendCommentLayout *)commentLayout {
    _commentLayout = commentLayout;
    
    WARFriendComment *comment = commentLayout.comment;
    
    self.textContentLabel.frame = commentLayout.contentLabelF;
    self.voiceView.frame = commentLayout.playAudioBtnF;
    self.mediaView.frame = commentLayout.collectionViewF;
    
    NSString* text = comment.totalTitle;
    self.textContentLabel.textLayout = commentLayout.textLayout;
    self.textContentLabel.hidden = kStringIsEmpty(text);
    self.mediaView.layout = commentLayout;
    
    if (!kObjectIsEmpty(comment.commentVoiceInfo)) {
        self.voiceView.hidden = NO;
        self.voiceView.voice = comment.commentVoiceInfo;
    }else{
        self.voiceView.hidden = YES;
    } 
}

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
        _textContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
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


- (WARFriendCommentMediaView *)mediaView{
    if (!_mediaView) {
        _mediaView = [[WARFriendCommentMediaView alloc] init];
        _mediaView.backgroundColor = [UIColor clearColor];
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
        _voiceView.backgroundColor = [UIColor clearColor];
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


@end
