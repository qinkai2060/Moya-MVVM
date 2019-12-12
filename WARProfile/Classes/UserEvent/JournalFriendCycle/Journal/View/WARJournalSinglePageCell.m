//
//  WARJournalSinglePageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalSinglePageCell.h"
#import "WARJournalTopView.h"
#import "WARJournalBottomView.h"
#import "WARJournalListLayout.h"
#import "WARMoment.h"
#import "UIColor+HEX.h" 
#import "UIImage+WARBundleImage.h"
#import "WARMomentPageContentView.h"

@interface WARJournalSinglePageCell()<WARMomentPageContentViewDelegate>

@property (nonatomic, strong) WARMomentPageContentView *singlePageContentView;

@end

@implementation WARJournalSinglePageCell

- (void)setUpUI{
    [super setUpUI];
    
    [self.contentView addSubview:self.singlePageContentView];
}

- (void)setMoment:(WARMoment *)moment {
    [super setMoment:moment];
    
    WARJournalListLayout <WARFeedModelProtocol>* momentLayout = moment.journalListLayout;
    self.singlePageContentView.pageLayoutArray = momentLayout.feedLayoutArr;
    
    //frame
    self.topView.frame = momentLayout.topViewFrame;
    self.singlePageContentView.frame = momentLayout.feedMainContentViewFrame;
    self.bottomView.frame = momentLayout.bottomViewFrame;
    
    //data
    self.topView.moment = moment;
    self.bottomView.moment = moment;
}

#pragma mark - WARMomentPageContentViewDelegate
 
- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView  {
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate journalBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:didLink:)]) {
        [self.delegate journalBaseCell:self didLink:link];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didGameLink:(WARFeedLinkComponent *)didGameLink {
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:didGameLink:)]) {
        [self.delegate journalBaseCell:self didGameLink:didGameLink];
    }
}

- (void)pageContentViewDidAllRank:(WARMomentPageContentView *)pageContentView game:(WARFeedGame *)game {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidAllRank:game:)]) {
        [self.delegate journalBaseCellDidAllRank:self game:game];
    }
}

#pragma mark - Setter And Getter

- (WARMomentPageContentView *)singlePageContentView {
    if (!_singlePageContentView) {
        _singlePageContentView = [[WARMomentPageContentView alloc]init];
        _singlePageContentView.delegate = self;
        _singlePageContentView.componentHasExtraHeight = YES;
    }
    return _singlePageContentView;
}

@end
