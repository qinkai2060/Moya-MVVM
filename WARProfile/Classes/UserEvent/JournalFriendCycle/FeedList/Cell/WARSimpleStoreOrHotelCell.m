//
//  WARSimpleStoreOrHotelCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARSimpleStoreOrHotelCell.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARFeedScoreView.h"

@interface WARSimpleStoreOrHotelCell()

/** 背景 */
@property (nonatomic, strong) UIView *contentBackgroundView;
/** 图片 */
@property (nonatomic, strong) UIImageView *iconView;
/** 文本 */
@property (nonatomic, strong) UILabel *contentLabel;
/** title */
@property (nonatomic, strong) UILabel *mainTitleLable;
/** 价格描述 */
@property (nonatomic, strong) UILabel *priceLable;
/** 地址 */
@property (nonatomic, strong) UILabel *locationLable;
/** 评分 */
@property (nonatomic, strong) WARFeedScoreView *scoreView;
@end

@implementation WARSimpleStoreOrHotelCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARSimpleStoreOrHotelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARSimpleStoreOrHotelCell"];
    if (!cell) {
        cell = [[[WARSimpleStoreOrHotelCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARSimpleStoreOrHotelCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, kContentLeftMargin, 10, 0));
    }];
    
    [self.contentBackgroundView addSubview:self.iconView];
    [self.contentBackgroundView addSubview:self.mainTitleLable];
    [self.contentBackgroundView addSubview:self.scoreView];
    [self.contentBackgroundView addSubview:self.priceLable];
    [self.contentBackgroundView addSubview:self.locationLable];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap]; 
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.baseDelegate respondsToSelector:@selector(feedCell:didComponent:)]) {
        [self.baseDelegate feedCell:self didComponent:self.layout.component];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    
    WARFeedStore  *store = layout.component.content.store;
    WARSimpleStoreOrHotelLayout *simpleStoreLayout = layout.simpleStoreLayout;
    
    if (layout.component.componentType == WARFeedComponentHotelType) {
        store = layout.component.content.hotel;
        simpleStoreLayout = layout.simpleHotelLayout;
    }
    
//    [self.iconView sd_setImageWithURL:store.mainImageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.iconView sd_setImageWithURL:kOriginMediaUrl(store.mainImageId) placeholderImage:DefaultPlaceholderImageWtihSize(simpleStoreLayout.imageFrame.size)];
    self.mainTitleLable.text = store.title;
    self.locationLable.text = store.location;
    self.priceLable.text = [NSString stringWithFormat:@"¥%@/人",store.price];
    [self.scoreView setScore:store.score];
    
    self.iconView.frame = simpleStoreLayout.imageFrame;
    self.scoreView.frame = simpleStoreLayout.scoreFrame;
    self.priceLable.frame = simpleStoreLayout.priceFrame;
    self.mainTitleLable.frame = simpleStoreLayout.titleFrame;
    self.locationLable.frame = simpleStoreLayout.locationFrame;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc]init];
        _contentBackgroundView.userInteractionEnabled = YES;
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF3F3F5);
    }
    return _contentBackgroundView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HEXCOLOR(0x343C4F);
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kLinkFontSize(18)];
    }
    return _contentLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)mainTitleLable {
    if (!_mainTitleLable) {
        _mainTitleLable = [[UILabel alloc]init];
        _mainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:kLinkFontSize(19)];
        _mainTitleLable.numberOfLines = 0;
        _mainTitleLable.textAlignment = NSTextAlignmentLeft;
        _mainTitleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _mainTitleLable;
}

- (UILabel *)locationLable {
    if (!_locationLable) {
        _locationLable = [[UILabel alloc]init];
        _locationLable.numberOfLines = 0;
        _locationLable.textAlignment = NSTextAlignmentLeft;
        _locationLable.textColor = HEXCOLOR(0x8D93A4);
        _locationLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kLinkFontSize(15)];
    }
    return _locationLable;
}

- (UILabel *)priceLable {
    if (!_priceLable) {
        _priceLable = [[UILabel alloc]init];
        _priceLable.numberOfLines = 0;
        _priceLable.textAlignment = NSTextAlignmentLeft;
        _priceLable.textColor = HEXCOLOR(0x343C4F);
        _priceLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kLinkFontSize(17)];
    }
    return _priceLable;
}

- (WARFeedScoreView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[WARFeedScoreView alloc] init];
//        _scoreView.backgroundColor = [UIColor redColor];
    }
    return _scoreView;
}

@end
