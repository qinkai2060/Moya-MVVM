//
//  WARFeedFourimageContainer.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFeedFourimageContainer.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARFeedMedia.h"
#import "WARFeedMacro.h"

static CGFloat contentPadding = 13;

@interface WARFeedFourimageContainer()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageArray;
/** coverImageView */
@property (nonatomic, strong) UIImageView *coverImageView;
/** countLable */
@property (nonatomic, strong) UILabel *countLable;

/** iconSize */
@property (nonatomic, assign) CGSize iconSize;
@end

@implementation WARFeedFourimageContainer

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;//10是lable在cell中的间距
    CGFloat margin = 2.5;
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = (maxWidth - 3 * margin) / 4;
    CGFloat imageH = imageW * 2 / 3;
    
    self.iconSize = CGSizeMake(imageW, imageH);
    for (int i = 0; i < 4; i++) {
        imageX = (imageW + margin) * i;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.backgroundColor = HEXCOLOR(0xF3F3F5);
        [self addSubview:imageView];
        
        if (i == 3) {
//            self.coverImageView.frame = CGRectMake(0, 0, imageW, imageH);
//            [imageView addSubview:self.coverImageView];
//
//            self.countLable.frame = CGRectMake(0, 0, imageW, imageH);
//            [self.coverImageView addSubview:self.countLable];

            self.coverImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            self.countLable.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [self addSubview:self.coverImageView];
            [self addSubview:self.countLable];
        }
        
        [self.imageArray addObject:imageView];
    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMedias:(NSArray<NSString *> *)medias {
    _medias = medias;
    
    NSInteger count = medias.count > 4 ? 4 : medias.count;
    for (int i = 0; i < count; i++) {
        NSString *imageId = medias[i];
        if (imageId) {
            self.imageArray[i].hidden = NO;
//            [self.imageArray[i] sd_setImageWithURL:imageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
            [self.imageArray[i] sd_setImageWithURL:kOriginMediaUrl(imageId) placeholderImage:DefaultPlaceholderImageWtihSize(self.iconSize)];
        } else {
            self.imageArray[i].hidden = YES;
        }
        
        if (i==3 && medias.count > 4) {
            self.coverImageView.hidden = NO;
            self.countLable.hidden = NO;
            
            self.countLable.text = [NSString stringWithFormat:@"+ %ld",(medias.count - 4)];
        } else {
            self.coverImageView.hidden = YES;
            self.countLable.hidden = YES;
        }
    }
}

- (NSMutableArray <UIImageView *>*)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray <UIImageView *>array];
    }
    return _imageArray;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.alpha = 0.4;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.hidden = YES;
    }
    return _coverImageView;
}

- (UILabel *)countLable {
    if (!_countLable) {
        _countLable = [[UILabel alloc]init];
        _countLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _countLable.numberOfLines = 1;
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.textColor = HEXCOLOR(0xffffff);
        _countLable.hidden = YES;
    }
    return _countLable;
}

@end
