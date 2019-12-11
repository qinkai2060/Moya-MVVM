//
//  WARMineExplorationSinglePageCell.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARMineExplorationSinglePageCell.h"

#import "UIColor+HEX.h"
#import "UIImage+WARBundleImage.h"

#import "WARMineExplorationTopView.h"
#import "WARMineExplorationBottomView.h"
#import "WARJournalListLayout.h"

#import "WARMomentPageContentView.h"

#import "WARMoment.h"

@interface WARMineExplorationSinglePageCell()<WARMomentPageContentViewDelegate>

@property (nonatomic, strong) WARMomentPageContentView *singlePageContentView;

@end

@implementation WARMineExplorationSinglePageCell


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
 
- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate mineExpBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCell:didLink:)]) {
        [self.delegate mineExpBaseCell:self didLink:link];
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
