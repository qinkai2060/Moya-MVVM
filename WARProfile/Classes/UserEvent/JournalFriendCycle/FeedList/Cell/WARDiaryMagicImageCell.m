//
//  WARDiaryMagicImageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/17.
//

#import "WARDiaryMagicImageCell.h"
#import "WARFeedMagicImageView.h"

//#import "WARPhotoBrowser.h"

//朋友圈
// cell 与屏幕间距
#define kCellContentMargin 11.5
// 头像宽高
#define kUserImageWidthHeight 42
// 头像与右边内容间距
#define kUserImageContentMargin 10

@interface WARDiaryMagicImageCell ()//<WARPhotoBrowserDelegate>
@property (nonatomic, strong) WARFeedMagicImageView *contentImgView;
@end

@implementation WARDiaryMagicImageCell

#pragma mark - Initial

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARDiaryMagicImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARDiaryMagicImageCell"];
    if (!cell) {
        cell = [[[WARDiaryMagicImageCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARDiaryMagicImageCell"];
    }
    return cell;
} 

- (void)setupSubViews{
    
    [super setupSubViews];
    
    [self.contentView addSubview:self.contentImgView];
    //    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 5, 5, 5));
    //    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didImage:)];
    [self.contentImgView addGestureRecognizer:tap];
}

#pragma mark - Event Response

- (void)didImage:(UITapGestureRecognizer *)tap {
    WARFeedImageComponent *didImageComponent = self.contentImgView.didImageComponent;
    if (didImageComponent == nil || didImageComponent.url == nil) {
        return ;
    }
    NDLog(@"didImageComponent:%@",didImageComponent.url);
    NSInteger index = [self.contentImgView.images indexOfObject:didImageComponent];
    if (didImageComponent == nil) {//容错处理
        if (self.contentImgView.images.count > 0) {
            index = 0;
        } else {
            return ;
        }
    }
//    if ([self.delegate respondsToSelector:@selector(didIndex:imageComponents:)]) {
//        [self.delegate didIndex:index imageComponents:self.contentImgView.images];
//    }
    if ([self.delegate respondsToSelector:@selector(didIndex:imageComponents:magicImageView:)]) {
        [self.delegate didIndex:index imageComponents:self.contentImgView.images magicImageView:self];
    }
    
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [self.contentImgView.images enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
//        if (obj.videoId && obj.videoId.length > 0) {
//            photoBrowserModel.videoURL = obj.videoId;
//            photoBrowserModel.thumbnailUrl = [kVideoCoverUrl(obj.videoId) absoluteString];;
//        } else {
//            photoBrowserModel.picUrl = [kCMPRPhotoUrl(obj.imgId) absoluteString];
//        }
//        [tempArray addObject:photoBrowserModel];
//    }];
//
//    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
//    photoBrowser.delegate = self;
//    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
//    photoBrowser.photoArray = tempArray;
//    photoBrowser.currentIndex = index;
//    [photoBrowser show];
}

#pragma mark - Delegate
//#pragma mark - WARPhotoBrowserDelegate

//- (CGRect)imageBrowser:(WARPhotoBrowser *)imageBrowser disappearFrameForIndex:(NSInteger)index {
//    WARFeedImageComponent *imageComponent = [self.contentImgView.images objectAtIndex:index];
//    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:imageComponent.listRect fromView:self];
//    return rect;
//}


#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    
    CGFloat imageScale = kImageTextScale;
    WARFeedComponentModel *component = layout.component;
    WARFeedImageComponent* img = component.content.pintu;
    
    CGSize imgSize = img.viewSizeSize;
    CGFloat imgW = layout.contentScale * imgSize.width * imageScale;
    CGFloat imgH = layout.contentScale * imgSize.height * imageScale;
  
    self.contentImgView.frame = CGRectMake(5, 5, imgW, imgH);
    self.contentImgView.contentScale = layout.contentScale * imageScale;
    self.contentImgView.images = component.content.images;
    
    if (img.pintuImage) {
        self.contentImgView.image = img.pintuImage;
    } else {
        [self.contentImgView sd_setImageWithURL:img.url placeholderImage:DefaultPlaceholderImage(component.content.pinTuSize,imgW)];
    }
    
//    self.contentImgView.layer.contentsRect = CGRectMake(0, 0, component.content.pinTuSize.height/imgSize.width, 1);
//    [self.contentImgView sd_setImageWithURL:img.url placeholderImage:DefaultUserIcon];
}
 
- (WARFeedMagicImageView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[WARFeedMagicImageView alloc] init];
        _contentImgView.layer.masksToBounds = YES;
        _contentImgView.tag = 100;
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.userInteractionEnabled = YES;
    }
    return _contentImgView;
}

@end
