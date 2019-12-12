//
//  WARUserDiarySinglePageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/7.
//

#import "WARUserDiarySinglePageCell.h"
#import "WARUserDiaryBaseCellTopView.h"
#import "WARUserDiaryBaseCellBottomView.h"

#import "WARNewUserDiaryMomentLayout.h"
#import "UIColor+HEX.h"

#import "UIImage+WARBundleImage.h"
#import "WARMomentPageContentView.h"
#import "WARNewUserDiaryModel.h"

@interface WARUserDiarySinglePageCell()<WARMomentPageContentViewDelegate>

@property (nonatomic, strong) WARMomentPageContentView *singlePageContentView;

@end

@implementation WARUserDiarySinglePageCell

- (void)setUpUI{
    [super setUpUI];
    
    [self.contentView addSubview:self.singlePageContentView];
}

- (void)setMoment:(WARNewUserDiaryMoment *)moment { 
    [super setMoment:moment];
    
    WARNewUserDiaryMomentLayout <WARFeedModelProtocol>* momentLayout = moment.momentLayout;
//    WARFeedPageLayout* pageLayout = [momentLayout.feedLayoutArr objectAtIndex:0];
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

- (void)didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCell:didImageIndex:imageComponents:)]) {
        [self.delegate userDiaryBaseCell:self didImageIndex:index imageComponents:imageComponents];
    }
}

- (void)pageContentView:(WARMomentPageContentView *)pageContentView didLink:(WARFeedLinkComponent *)content {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCell:didLink:)]) {
        [self.delegate userDiaryBaseCell:self didLink:content];
    }
}

#pragma mark - Setter And Getter

- (WARMomentPageContentView *)singlePageContentView {
    if (!_singlePageContentView) {
        _singlePageContentView = [[WARMomentPageContentView alloc]init];
        _singlePageContentView.delegate = self;
    }
    return _singlePageContentView;
}

@end
