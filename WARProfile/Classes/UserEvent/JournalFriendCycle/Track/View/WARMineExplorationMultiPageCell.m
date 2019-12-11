//
//  WARMineExplorationMultiPageCell.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARMineExplorationMultiPageCell.h"

#import "UIColor+HEX.h"
#import "UIImage+WARBundleImage.h"

#import "WARMineExplorationTopView.h"
#import "WARMineExplorationBottomView.h"
#import "WARJournalListLayout.h"
#import "WARFeedMainContentView.h"

#import "WARMoment.h"

@interface WARMineExplorationMultiPageCell()<WARFeedMainContentViewDelegate>

@property (nonatomic, strong) WARFeedMainContentView *feedMainContentView;

@property (nonatomic, strong) WARJournalListLayout *layout;

@end

@implementation WARMineExplorationMultiPageCell

- (void)setUpUI{
    [super setUpUI];
    
    [self.contentView addSubview:self.feedMainContentView];
}

- (void)setMoment:(WARMoment *)moment {
    [super setMoment:moment];
    
    WARJournalListLayout <WARFeedModelProtocol>* momentLayout = moment.journalListLayout;
    self.feedMainContentView.modelProtocol = momentLayout;
    
    //frame
    self.topView.frame = momentLayout.topViewFrame;
    self.feedMainContentView.frame = momentLayout.feedMainContentViewFrame;
    self.bottomView.frame = momentLayout.bottomViewFrame;
    
    //data
    self.topView.moment = moment;
    self.bottomView.moment = moment;
}

#pragma mark - WARFeedMainContentViewDelegate

- (void)didFeedMainContentView:(WARFeedMainContentView *)feedMainContentView {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCell:actionType:value:)]) {
        [self.delegate mineExpBaseCell:self actionType:(WARMineExpCellActionTypeDidPageContent) value:self.moment];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didLink:(WARFeedLinkComponent *)content {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCell:didLink:)]) {
        [self.delegate mineExpBaseCell:self didLink:content];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate mineExpBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}

#pragma mark - Setter And Getter

- (WARFeedMainContentView *)feedMainContentView {
    if (!_feedMainContentView) {
        _feedMainContentView = [[WARFeedMainContentView alloc]init];
        _feedMainContentView.delegate = self;
        _feedMainContentView.frame = CGRectMake(0, kContentLeftMargin, kScreenWidth - kContentLeftMargin, kFeedMainContentViewHeight);
    }
    return _feedMainContentView;
}


@end
