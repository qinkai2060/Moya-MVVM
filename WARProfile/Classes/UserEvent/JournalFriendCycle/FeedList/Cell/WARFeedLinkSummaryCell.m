//
//  WARFeedLinkSummaryCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedLinkSummaryCell.h"
#import "WARFeedSummaryTextView.h"
#import "WARFeedMediaView.h"

@interface WARFeedLinkSummaryCell()
/** textView */
@property (nonatomic, strong) WARFeedSummaryTextView *textView;
/** mediaView */
@property (nonatomic, strong) WARFeedMediaView *mediaView;
/** 背景link*/
@property (nonatomic, strong) UIView *contentBackgroundView;
@end

@implementation WARFeedLinkSummaryCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedLinkSummaryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedLinkSummaryCell"];
    if (!cell) {
        cell = [[[WARFeedLinkSummaryCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedLinkSummaryCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(UIEdgeInsetsMake(0, kContentLeftMargin, 0, 0));
    }];
    
    [self.contentBackgroundView addSubview:self.textView];
    [self.contentBackgroundView addSubview:self.mediaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap]; 
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(linkSummaryCell:didLink:)]) {
        [self.delegate linkSummaryCell:self didLink:self.layout.component.content.link];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    WARFeedLinkLayout *linkLayout = layout.linkLayout;
    
    self.textView.layout = layout;
    self.mediaView.layout = layout;
    
    /// 微博样式背景为白色
    if (linkLayout.linkComponent.linkType == WARFeedLinkComponentTypeWeiBo) {
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
    } else {
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF3F3F5);
    }
    
    self.textView.frame = linkLayout.summaryTextViewFrame;
    self.mediaView.frame = linkLayout.mediaViewFrame;
}

- (WARFeedSummaryTextView *)textView {
    if (!_textView) {
        _textView = [[WARFeedSummaryTextView alloc]init]; 
    }
    return _textView;
}

- (WARFeedMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[WARFeedMediaView alloc]init];
    }
    return _mediaView;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc]init];
        _contentBackgroundView.userInteractionEnabled = YES;
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF3F3F5);
    }
    return _contentBackgroundView;
}

@end
