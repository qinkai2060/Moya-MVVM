//
//  WARJournalMultiPageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalMultiPageCell.h"
#import "WARJournalTopView.h"
#import "WARJournalBottomView.h"
#import "WARFeedMainContentView.h"
#import "UIColor+HEX.h"
#import "UIImage+WARBundleImage.h"
#import "WARJournalListLayout.h"
#import "WARMoment.h"

#define kContentLeftMargin 63.5

@interface WARJournalMultiPageCell()<WARFeedMainContentViewDelegate>

@property (nonatomic, strong) WARFeedMainContentView *feedMainContentView;

@property (nonatomic, strong) WARJournalListLayout *layout;

@end

@implementation WARJournalMultiPageCell

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
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:actionType:value:)]) {
        [self.delegate journalBaseCell:self actionType:(WARJournalBaseCellActionTypeDidPageContent) value:self.moment];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didLink:(WARFeedLinkComponent *)content {
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:didLink:)]) {
        [self.delegate journalBaseCell:self didLink:content];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(journalBaseCell:didImageIndex:imageComponents:magicImageView:)]) {
        [self.delegate journalBaseCell:self didImageIndex:index imageComponents:imageComponents magicImageView:magicImageView];
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
