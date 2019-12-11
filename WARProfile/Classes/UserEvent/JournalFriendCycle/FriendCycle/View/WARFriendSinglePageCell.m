//
//  WARFriendSinglePageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/7.
//

#import "WARFriendSinglePageCell.h"
#import "WARFriendTopView.h"
#import "WARFriendBottomView.h"
#import "WARFriendCommentView.h"
#import "WARFriendLikeView.h"

#import "WARFriendMomentLayout.h"
#import "UIColor+HEX.h"
#import "UIImage+WARBundleImage.h"
#import "WARMomentPageContentView.h"

#import "WARMoment.h"

@interface WARFriendSinglePageCell()<WARMomentPageContentViewDelegate>
@property (nonatomic, strong) WARMomentPageContentView *singlePageContentView;
@end

@implementation WARFriendSinglePageCell

#pragma mark - System

- (void)setUpUI{
    [super setUpUI];
    
    [self.contentView addSubview:self.singlePageContentView];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARMomentPageContentViewDelegate
  
- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate friendBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didLink:)]) {
        [self.delegate friendBaseCell:self didLink:link];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didGameLink:(WARFeedLinkComponent *)didGameLink {
    if ([self.delegate respondsToSelector:@selector(friendBaseCell:didGameLink:)]) {
        [self.delegate friendBaseCell:self didGameLink:didGameLink];
    }
}

- (void)pageContentViewDidAllRank:(WARMomentPageContentView *)pageContentView game:(WARFeedGame *)game {
    if ([self.delegate respondsToSelector:@selector(friendBaseCellDidAllRank:game:)]) {
        [self.delegate friendBaseCellDidAllRank:self game:game];
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)hideLikeView:(BOOL)hide {
    self.likeView.hidden = hide;
}

- (void)hideCommentView:(BOOL)hide {
    self.commentView.hidden = hide;
} 

- (void)setMoment:(WARMoment *)moment {
    [super setMoment:moment];
    
    //content layout
    WARFriendMomentLayout <WARFeedModelProtocol>* friendMomentLayout = moment.friendMomentLayout;
    self.singlePageContentView.pageLayoutArray = friendMomentLayout.feedLayoutArr;
    
    //frame
    self.topView.frame = friendMomentLayout.topViewFrame;
    self.singlePageContentView.frame = friendMomentLayout.feedMainContentViewFrame;
    self.bottomView.frame = friendMomentLayout.bottomViewFrame;
    self.arrowImageView.frame = friendMomentLayout.arrowImageFrame;
    self.separatorView.frame = friendMomentLayout.separatorFrame;
    
    //data
    self.topView.moment = moment;
    self.bottomView.moment = moment;
    
    if (moment.momentShowType == WARMomentShowTypeFriendFollow) {
        self.likeView.hidden = YES;
        self.commentView.hidden = YES;
    } else {
        self.likeView.frame = friendMomentLayout.likeViewFrame;
        self.commentView.frame = friendMomentLayout.commentViewFrame;
        self.likeView.moment = moment;
        self.commentView.comments = [NSMutableArray arrayWithArray:moment.commentsLayoutArr];
        
        self.likeView.hidden = NO;
        self.commentView.hidden = NO;
    }
}

- (WARMomentPageContentView *)singlePageContentView {
    if (!_singlePageContentView) {
        _singlePageContentView = [[WARMomentPageContentView alloc]init];
        _singlePageContentView.delegate = self;
    }
    return _singlePageContentView;
}

@end
