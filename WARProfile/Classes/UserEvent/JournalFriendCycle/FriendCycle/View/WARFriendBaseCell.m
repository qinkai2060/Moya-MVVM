//
//  WARFriendBaseCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendBaseCell.h"
#import "WARFriendTopView.h"
#import "WARFriendBottomView.h"
#import "WARFriendCommentView.h"
#import "WARFriendLikeView.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Frame.h"
#import "YYLabel.h"
#import "YYTextAttribute.h"
#import "NSAttributedString+YYText.h"

#import "WARMoment.h"

@interface WARFriendBaseCell()<WARFriendTopViewDelegate,WARFriendBottomViewDelegate,WARFriendLikeViewDelegate,WARFriendCommentViewDelegate>
 

@end

@implementation WARFriendBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor); 
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.likeView];
    [self.contentView addSubview:self.commentView];
    [self.contentView addSubview:self.separatorView];
}

- (void)showTopView:(BOOL)show {
    self.topView.hidden = !show;
}

- (void)showBottomView:(BOOL)show {
    self.bottomView.hidden = !show;
}

- (void)showTopExtendView:(BOOL)show {
    [self.topView showExtendView:show];
}

- (void)showBottomSeparatorView:(BOOL)show {
    [self.bottomView showSeparatorView:show];
}

- (void)hideLikeView:(BOOL)hide {
    self.likeView.hidden = hide;
}

- (void)hideCommentView:(BOOL)hide {
    self.commentView.hidden = hide;
}

- (void)hideCellSeparatorView:(BOOL)hide {
    self.separatorView.hidden = hide;
}

#pragma mark - WARFriendTopViewDelegate

- (void)friendTopViewShowPop:(WARFriendTopView *)topView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame popType:(WARFriendTopPopType)popType {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellShowPop:actionType:indexPath:showFrame:)]) {
        switch (popType) {
                case WARFriendTopPopTypeAd:
            {
                [self.delegate friendBaseCellShowPop:self actionType:(WARFriendBaseCellActionTypeDidTopPopAd) indexPath:indexPath showFrame:frame];
            }
                break;
                case WARFriendTopPopTypeNormal:
            {
                [self.delegate friendBaseCellShowPop:self actionType:(WARFriendBaseCellActionTypeDidTopPop) indexPath:indexPath showFrame:frame];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)friendTopViewDidUserHeader:(WARFriendTopView *)topView indexPath:(NSIndexPath *)indexPath model:(WARDBContactModel *)model{
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidUserHeader:indexPath:model:)]) {
        [self.delegate friendBaseCellDidUserHeader:self indexPath:indexPath model:model];
    }
}

#pragma mark - WARFriendBottomViewDelegate

- (void)friendBottomViewShowPop:(WARFriendBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellShowPop:actionType:indexPath:showFrame:)]) {
        [self.delegate friendBaseCellShowPop:self actionType:(WARFriendBaseCellActionTypeDidBottomPop) indexPath:indexPath showFrame:frame];
    }
}

-(void)friendBottomViewDidNoInterest:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidNoInterest:indexPath:)]) {
        [self.delegate friendBaseCellDidNoInterest:self indexPath:indexPath];
    }
}

-(void)friendBottomViewDidAllContext:(WARFriendBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath { 
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidAllContext:indexPath:)]) {
        [self.delegate friendBaseCellDidAllContext:self indexPath:indexPath];
    }
}

- (void)friendBottomViewDidPriase:(WARFriendBottomView *)bottomView indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:actionType:value:)]) {
        [self.delegate friendBaseCell:self actionType:(WARFriendBaseCellActionTypeDidPraise) value:indexPath];
    }
}

- (void)friendBottomViewDidComment:(WARFriendBottomView *)bottomView indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:actionType:value:)]) {
        [self.delegate friendBaseCell:self actionType:(WARFriendBaseCellActionTypeDidFollowComment) value:indexPath];
    }
}

-(void)friendBottomViewDidDelete:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidDelete:moment:)]) {
        [self.delegate friendBaseCellDidDelete:self moment:moment];
    }
}

-(void)friendBottomViewDidEdit:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidEdit:moment:)]) {
        [self.delegate friendBaseCellDidEdit:self moment:moment];
    }
}

-(void)friendBottomViewDidLock:(WARFriendBottomView *)bottomView moment:(WARMoment *)moment lock:(BOOL)lock {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidLock:moment:lock:)]) {
        [self.delegate friendBaseCellDidLock:self moment:moment lock:lock];
    }
}

#pragma mark - WARFriendLikeViewDelegate

- (void)likeView:(WARFriendLikeView *)likeView didThumber:(NSString *)accountId {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didUser:)]) {
        [self.delegate friendBaseCell:self didUser:accountId];
    }
}

- (void)likeView:(WARFriendLikeView *)likeView didOpen:(BOOL)open {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didOpen:indexPath:)]) {
        [self.delegate friendBaseCell:self didOpen:open indexPath:self.indexPath];
    }
}

#pragma mark - WARFriendCommentViewDelegate

/// 点击评论的cell
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView didComment:(WARFriendComment *)comment {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:moment:didComment:)] ) {
        [self.delegate friendBaseCell:self moment:self.moment didComment:comment];
    }
}

/// 图片浏览
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:showPhotoBrower:currentIndex:)]) {
        [self.delegate friendBaseCell:self showPhotoBrower:photos currentIndex:index];
    }
}

/// 视频播放
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView playVideoWithUrl:(NSString *)accountId {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:playVideoWithUrl:)]) {
        [self.delegate friendBaseCell:self playVideoWithUrl:accountId];
    }
}

/// 头像点击
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView tapIconWithAccountId:(NSString*)accountId {
    
}

/// 点击了 Label 的链接
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    WARMomentUser *user = (WARMomentUser *)info[kLinkReplyName];
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didUser:)] && user.accountId) {
        [self.delegate friendBaseCell:self didUser:user.accountId];
    }
}

/// 播放音频
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView audioPlay:(WARMomentVoice*)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:audioPlay:playBtn:voiceView:)]) {
        [self.delegate friendBaseCell:self audioPlay:audio playBtn:sender voiceView:voiceView];
    }
}

#pragma mark - getter methods

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.topView.indexPath = indexPath;
    self.bottomView.indexPath = indexPath;
}

- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
}

- (WARFriendTopView *)topView {
    if (!_topView) {
        _topView = [[WARFriendTopView alloc]init];
        _topView.delegate = self;
        _topView.frame = CGRectMake(0, 0, kScreenWidth, 62);
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (WARFriendBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[WARFriendBottomView alloc]init];
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImage *image = [UIImage war_imageName:@"group_arrow" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = image;
//        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

- (WARFriendCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[WARFriendCommentView alloc]init];
        _commentView.delegate = self;
        _commentView.backgroundColor = HEXCOLOR(0xF4F4F6);
    }
    return _commentView;
}

- (WARFriendLikeView *)likeView {
    if (!_likeView) {
        _likeView = [[WARFriendLikeView alloc]init];
        _likeView.delegate = self;
        _likeView.backgroundColor = HEXCOLOR(0xF4F4F6);
    }
    return _likeView;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = HEXCOLOR(0xDCDEE6);//[UIColor redColor];//HEXCOLOR(0xDCDEE6);
    }
    return _separatorView;
}
@end
