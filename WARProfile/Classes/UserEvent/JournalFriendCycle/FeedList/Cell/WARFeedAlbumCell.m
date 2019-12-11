//
//  WARFeedAlbumCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARFeedAlbumCell.h"
#import "WARFeedAlbum.h"
#import "WARLabel.h"
#import "UIImageView+WARAlbum.h"

@interface WARFeedAlbumCell()
/** 封面 */
@property (nonatomic, strong) UIImageView *iconView;
/** 收藏夹名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 显示图片数量 */
@property (nonatomic, strong) WARLabel *countLabel;
/** 页层效果 */
@property (nonatomic, strong) CAGradientLayer *shadowLayer;
@end

@implementation WARFeedAlbumCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedAlbumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedAlbumCell"];
    if (!cell) {
        cell = [[[WARFeedAlbumCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedAlbumCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView.layer addSublayer:self.shadowLayer];
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.iconView addSubview:self.countLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.iconView addGestureRecognizer:tap];
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
    
    WARFeedAlbum *album = layout.component.content.album;
    WARFeedAlbumLayout *albumLayout = layout.albumLayout;
    
    if (layout.component.componentType == WARFeedComponentFavourType) {
        album = layout.component.content.favour;
        albumLayout = layout.favourLayout;
    }
    
    [self.iconView sd_setImageWithURL:album.coverId placeholderImage:DefaultPlaceholderImageWtihSize(albumLayout.imageFrame.size)];
    self.nameLabel.text = album.name;
    self.countLabel.text = [NSString stringWithFormat:@"%ld张  ",album.photoCount];
    
    self.iconView.frame = albumLayout.imageFrame;
    self.nameLabel.frame = albumLayout.titleFrame;
    self.countLabel.frame = albumLayout.countFrame;
    self.shadowLayer.frame = albumLayout.shadowLayerFrame;
}

//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    CGRect rect = CGRectMake(0, 0, self.width - 3, self.height*0.78 + 3);
//    // UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radus, radus)];
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:rect];
//    self.shadowLayer.frame = rect;
//    self.shadowLayer.shadowPath = path.CGPath;
//}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleToFill;
        _iconView.layer.shadowColor = [UIColor colorWithHexString:@"9BA0AF"].CGColor;
        _iconView.layer.shadowOffset = CGSizeMake(0, 0);
        _iconView.layer.shadowOpacity = 0.75;
        _iconView.layer.shadowRadius = 2.0;
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kFeedNumber(14)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"386DB4"];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}


- (CAGradientLayer *)shadowLayer{
    if (!_shadowLayer) {
        _shadowLayer = [CAGradientLayer new];
        _shadowLayer.frame = self.bounds;
        _shadowLayer.colors = @[[UIColor colorWithHexString:@"BABABA"],
                                [UIColor colorWithHexString:@"FFFFFF"],
                                [UIColor colorWithHexString:@"D2D2D2"],
                                [UIColor colorWithHexString:@"FFFFFF"]];
        _shadowLayer.locations = @[@0.2, @0.4, @0.6, @0.8];
        _shadowLayer.borderColor = [UIColor colorWithHexString:@"897D7F"].CGColor;
        _shadowLayer.borderWidth = 1.0f;
        _shadowLayer.backgroundColor = [UIColor colorWithHexString:@"D2D2D2" opacity:0.8].CGColor;
        //        _shadowLayer.shadowColor = [UIColor colorWithHexString:@"9BA0AF"].CGColor;
        //        _shadowLayer.shadowOffset = CGSizeMake(0, 0);
        //        _shadowLayer.shadowOpacity = 0.75;
        //        _shadowLayer.shadowRadius = 2.0;
    }
    return _shadowLayer;
}

- (WARLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[WARLabel alloc]init];
        _countLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:kFeedNumber(14)];
        _countLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _countLabel.backgroundColor = [UIColor colorWithHexString:@"000000" opacity:0.3];
        _countLabel.numberOfLines = 0;
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    return _countLabel;
}

@end
