//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "WARDouYinCell.h"
#import "WARRecommendVideo.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"

@interface WARDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation WARDouYinCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARDouYinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARDouYinCell"];
    if (!cell) {
        cell = [[[WARDouYinCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARDouYinCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
}

- (void)setVideo:(WARRecommendVideo *)video {
    _video = video;
    [self.coverImageView sd_setImageWithURL:kVideoCoverUrl(video.url) placeholderImage:[WARUIHelper war_defaultUserIcon]];
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}
 
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self.contentView addSubview:self.coverImageView];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.coverImageView.frame = self.contentView.bounds;
//}
//
//- (void)setVideo:(WARRecommendVideo *)video {
//    _video = video;
//    [self.coverImageView sd_setImageWithURL:kVideoCoverUrl(video.url) placeholderImage:[WARUIHelper war_defaultUserIcon]];
//}
//
//- (UIImageView *)coverImageView {
//    if (!_coverImageView) {
//        _coverImageView = [[UIImageView alloc] init];
//        _coverImageView.userInteractionEnabled = YES;
//        _coverImageView.backgroundColor = [UIColor blackColor];
//        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _coverImageView;
//}

@end
