//
//  WARFriendPageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendPageCell.h"
#import "WARFeedMainContentView.h"
#import "WARFriendTopView.h"
#import "WARFriendBottomView.h"
#import "WARFriendCommentView.h"
#import "WARFriendLikeView.h"
 
#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "UIColor+HEX.h"
#import "UIImage+WARBundleImage.h"

#define kContentLeftMargin 63.5


@interface WARFriendPageCell()<WARFeedMainContentViewDelegate>

@property (nonatomic, strong) WARFeedMainContentView *feedMainContentView;
@property (nonatomic, strong) WARFriendMomentLayout *layout;

@end

@implementation WARFriendPageCell

- (void)setUpUI{
    [super setUpUI];
    
    [self.contentView addSubview:self.feedMainContentView];
}

#pragma mark - WARFeedMainContentViewDelegate

- (void)didFeedMainContentView:(WARFeedMainContentView *)feedMainContentView {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:actionType:value:)]) {
        [self.delegate friendBaseCell:self actionType:(WARFriendBaseCellActionTypeDidPageContent) value:self.moment];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView scrollToLeft:(BOOL)scrollToLeft {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:actionType:value:)]) {
        [self.delegate friendBaseCell:self actionType:(WARFriendBaseCellActionTypeScrollHorizontalPage) value:@(scrollToLeft)];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView finishHorizontalScroll:(BOOL)finishHorizontalScroll {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:actionType:value:)]) {
        [self.delegate friendBaseCell:self actionType:(WARFriendBaseCellActionTypeFinishScrollHorizontalPage) value:@(finishHorizontalScroll)];
    }
}
 
- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didLink:)]) {
        [self.delegate friendBaseCell:self didLink:link];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didGameLink:(WARFeedLinkComponent *)didGameLink {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didGameLink:)]) {
        [self.delegate friendBaseCell:self didGameLink:didGameLink];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate friendBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}
  
#pragma mark - Setter And Getter

- (void)hideLikeView:(BOOL)hide {
    self.likeView.hidden = hide;
}

- (void)hideCommentView:(BOOL)hide {
    self.commentView.hidden = hide;
}
 
- (void)setMoment:(WARMoment *)moment {
    [super setMoment:moment];
    
    WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = moment.friendMomentLayout;
    self.feedMainContentView.modelProtocol = friendMomentLayout;
    
    //frame
    self.topView.frame = friendMomentLayout.topViewFrame;
    self.feedMainContentView.frame = friendMomentLayout.feedMainContentViewFrame;
    self.bottomView.frame = friendMomentLayout.bottomViewFrame;
    self.arrowImageView.frame = friendMomentLayout.arrowImageFrame;
    self.separatorView.frame = friendMomentLayout.separatorFrame;
    
    //data
    self.topView.moment = moment;
    self.bottomView.moment = moment;
    
    if (moment.momentShowType == WARMomentShowTypeFriendFollow) {
        self.likeView.hidden = YES;
        self.commentView.hidden = YES;
        self.arrowImageView.hidden = YES;
    } else {
        self.likeView.frame = friendMomentLayout.likeViewFrame;
        self.commentView.frame = friendMomentLayout.commentViewFrame;
        self.likeView.moment = moment;
        self.commentView.comments = [NSMutableArray arrayWithArray:moment.commentsLayoutArr];
        
        self.likeView.hidden = NO;
        self.commentView.hidden = NO;
        self.arrowImageView.hidden = NO;
        
        if (moment.commentWapper.thumb.thumbUserBos.count > 0 && moment.commentWapper.comment.comments.count > 0) {
            [self.commentView hideLineView:NO];
        } else {
            [self.commentView hideLineView:YES];
        }
    }
}

- (WARFeedMainContentView *)feedMainContentView {
    if (!_feedMainContentView) {
        _feedMainContentView = [[WARFeedMainContentView alloc]init];
        _feedMainContentView.delegate = self;
        _feedMainContentView.frame = CGRectMake(0, kContentLeftMargin, kScreenWidth - kContentLeftMargin, kFeedMainContentViewHeight);
    }
    return _feedMainContentView;
}

@end
