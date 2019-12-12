//
//  WARFeedMagicImageCell.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedMagicImageCell.h"
#import "WARFeedMagicImageView.h"

//朋友圈
// cell 与屏幕间距
#define kCellContentMargin 11.5
// 头像宽高
#define kUserImageWidthHeight 42
// 头像与右边内容间距
#define kUserImageContentMargin 10


@interface WARFeedMagicImageCell ()
@property (nonatomic, strong) WARFeedMagicImageView *contentImgView;
@end

@implementation WARFeedMagicImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedMagicImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedMagicImageCell"];
    if (!cell) {
        cell = [[[WARFeedMagicImageCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedMagicImageCell"];
    }
    return cell;
}


- (void)setupSubViews{
    [super setupSubViews];
     
    [self.contentView addSubview:self.contentImgView]; 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didImage:)];
    [self.contentImgView addGestureRecognizer:tap];
}

- (void)didImage:(UITapGestureRecognizer *)tap {
    WARFeedImageComponent *didImageComponent = self.contentImgView.didImageComponent;
    NDLog(@"didImageComponent:%@",didImageComponent.url);
    if (didImageComponent == nil || didImageComponent.url == nil) {
        return ;
    } 
    NSInteger index = [self.contentImgView.images indexOfObject:didImageComponent];
    if (didImageComponent == nil) {//容错处理
        if (self.contentImgView.images.count > 0) {
            index = 0;
        } else {
            return ;
        }
    }
    if ([self.delegate respondsToSelector:@selector(didIndex:imageComponents:magicImageView:)]) {
        [self.delegate didIndex:index imageComponents:self.contentImgView.images magicImageView:self];
    }
}
 
- (void)setLayout:(WARFeedComponentLayout *)layout{
    
    [super setLayout:layout];
 
    WARFeedComponentModel *component = layout.component;
    WARFeedImageComponent* img = component.content.pintu;
    
    //多页高度
//    CGFloat multilPageViewHeight = layout.contentScale * kFeedMultilPageViewHeight + 20;
    //图片宽高
    CGSize imgSize = img.viewSizeSize;
    CGFloat imgW = layout.contentScale * imgSize.width;
    CGFloat imgH = layout.contentScale * imgSize.height;
    if (imgW == 0) {
        imgW = layout.contentScale * img.imgW.floatValue;
        imgH = layout.contentScale * img.imgH.floatValue;
    }
    
    CGFloat contentWidth = kScreenWidth - 9;
    if (layout.contentScale < 1 && layout.contentScale > 0) {
        contentWidth = kScreenWidth - (kUserImageContentMargin + kUserImageWidthHeight + 2 * kCellContentMargin + 3);
    } else {
        
    }
    self.contentImgView.frame = CGRectMake(5, 5, imgW, imgH);
    self.contentImgView.contentScale = layout.contentScale;
    self.contentImgView.images = component.content.images;
//    [self.contentImgView sd_setImageWithURL:img.url placeholderImage:DefaultUserIcon];
    
    if (img.pintuImage) {
        self.contentImgView.image = img.pintuImage;
    } else {
        [self.contentImgView sd_setImageWithURL:img.url placeholderImage:DefaultPlaceholderImage(component.content.pinTuSize,imgW)];
    }
}

- (WARFeedMagicImageView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[WARFeedMagicImageView alloc] init];
        _contentImgView.layer.masksToBounds = YES;
        _contentImgView.tag = 100;
        _contentImgView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImgView.userInteractionEnabled = YES;
    }
    return _contentImgView;
}

@end
