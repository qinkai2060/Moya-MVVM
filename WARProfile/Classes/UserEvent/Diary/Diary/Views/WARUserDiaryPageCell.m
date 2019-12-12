//
//  WARUserDiaryPageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import "WARUserDiaryPageCell.h"
#import "WARUserDiaryBaseCellTopView.h"
#import "WARUserDiaryBaseCellBottomView.h"

#import "WARNewUserDiaryMomentLayout.h"
#import "WARFeedMainContentView.h"
#import "UIColor+HEX.h"

#import "UIImage+WARBundleImage.h"

#import "WARNewUserDiaryModel.h"

#define kContentLeftMargin 63.5


@interface WARUserDiaryPageCell()<WARFeedMainContentViewDelegate>

@property (nonatomic, strong) WARFeedMainContentView *feedMainContentView;

@property (nonatomic, strong) WARNewUserDiaryMomentLayout *layout;

@end

@implementation WARUserDiaryPageCell

- (void)setUpUI{
    [super setUpUI];
     
    [self.contentView addSubview:self.feedMainContentView];
}

- (void)setMoment:(WARNewUserDiaryMoment *)moment {
    [super setMoment:moment];
    
    WARNewUserDiaryMomentLayout <WARFeedModelProtocol>* momentLayout = moment.momentLayout;
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

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didLink:(WARFeedLinkComponent *)content {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCell:didLink:)]) {
        [self.delegate userDiaryBaseCell:self didLink:content];
    }
}

- (void)feedMainContentView:(WARFeedMainContentView *)feedMainContentView didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCell:didImageIndex:imageComponents:)]) {
        [self.delegate userDiaryBaseCell:self didImageIndex:index imageComponents:imageComponents];
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
