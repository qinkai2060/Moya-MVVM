//
//  WARSimpleSceneryCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARSimpleSceneryCell.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

@interface WARSimpleSceneryCell() 
/** 背景 */
@property (nonatomic, strong) UIView *contentBackgroundView;
/** 图片 */
@property (nonatomic, strong) UIImageView *iconView;
/** title */
@property (nonatomic, strong) UILabel *mainTitleLable;
/** 地址 */
@property (nonatomic, strong) UILabel *locationLable;
@end

@implementation WARSimpleSceneryCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARSimpleSceneryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARSimpleSceneryCell"];
    if (!cell) {
        cell = [[[WARSimpleSceneryCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARSimpleSceneryCell"];
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
    
    WARFeedScenery *scenery = layout.component.content.scenery;
    WARSimpleSceneryLayout *simpleSceneryLayout = layout.simpleSceneryLayout;
    
//    [self.iconView sd_setImageWithURL:scenery.mainImageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.iconView sd_setImageWithURL:kOriginMediaUrl(scenery.mainImageId) placeholderImage:DefaultPlaceholderImageWtihSize(simpleSceneryLayout.imageFrame.size)];
    self.mainTitleLable.text = scenery.title;
    self.locationLable.text = scenery.location;
    
    self.iconView.frame = simpleSceneryLayout.imageFrame;
    self.mainTitleLable.frame = simpleSceneryLayout.titleFrame;
    self.locationLable.frame = simpleSceneryLayout.locationFrame;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc]init];
        _contentBackgroundView.userInteractionEnabled = YES;
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF3F3F5);
    }
    return _contentBackgroundView;
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
@end
