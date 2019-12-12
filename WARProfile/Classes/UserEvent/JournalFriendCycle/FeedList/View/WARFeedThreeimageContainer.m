//
//  WARFeedThreeimageContainer.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedThreeimageContainer.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARFeedMedia.h"
#import "WARFeedMacro.h"

static CGFloat contentPadding = 13;

@interface WARFeedThreeimageContainer()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageArray;
/** <#Description#> */
@property (nonatomic, assign) CGSize iconSize;
@end

@implementation WARFeedThreeimageContainer

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
    CGFloat margin = 3.5;
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = (maxWidth - 2 * margin) / 3;
    CGFloat imageH = imageW * 2 / 3;
    
    self.iconSize = CGSizeMake(imageW, imageH);
    for (int i = 0; i < 3; i++) {
        imageX = (imageW + margin) * i;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.backgroundColor = HEXCOLOR(0xF3F3F5);
        [self addSubview:imageView];
        
        [self.imageArray addObject:imageView];
    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMedias:(NSArray<WARFeedMedia *> *)medias {
    _medias = medias;
    
    NSInteger count = medias.count > 3 ? 3 : medias.count;
    for (int i = 0; i < count; i++) {
        WARFeedMedia *media = medias[i];
        if (media.imgId) {
            self.imageArray[i].hidden = NO;
//            [self.imageArray[i] sd_setImageWithURL:media.imgId placeholderImage:[WARUIHelper war_defaultUserIcon]];
            [self.imageArray[i] sd_setImageWithURL:kOriginMediaUrl(media.imgId) placeholderImage:DefaultPlaceholderImageWtihSize(self.iconSize)];
        } else {
            self.imageArray[i].hidden = YES;
        }
    }
}

- (NSMutableArray <UIImageView *>*)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray <UIImageView *>array];
    }
    return _imageArray;
}

@end
