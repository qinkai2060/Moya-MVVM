//
//  WARFeedLinkSummaryTextView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedSummaryTextView.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

@interface WARFeedSummaryTextView()

@property (nonatomic, strong) UILabel *mainTitleLable;
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation WARFeedSummaryTextView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.mainTitleLable];
    [self addSubview:self.contentLable]; 
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    _layout = layout;
    
    WARFeedLinkComponent *link = layout.component.content.link;
    WARFeedLinkLayout *linkLayout = layout.linkLayout;
    
    self.mainTitleLable.text = link.title;
    self.contentLable.text = link.subTitle;
    
    self.mainTitleLable.frame = linkLayout.mainTitleLableFrame;
    self.contentLable.frame = linkLayout.contentLableFrame;
}
 
- (UILabel *)mainTitleLable {
    if (!_mainTitleLable) {
        _mainTitleLable = [[UILabel alloc]init];
        _mainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18 * kLinkContentScale];
        _mainTitleLable.numberOfLines = 0;
        _mainTitleLable.textAlignment = NSTextAlignmentLeft;
        _mainTitleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _mainTitleLable;
}

- (UILabel *)contentLable {
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]init];
        _contentLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * kLinkContentScale];
        _contentLable.textAlignment = NSTextAlignmentLeft;
        _contentLable.textColor = HEXCOLOR(0x343C4F);
        _contentLable.numberOfLines = 5;
    }
    return _contentLable;
}

@end
