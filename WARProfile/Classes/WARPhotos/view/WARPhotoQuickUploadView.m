//
//  WARPhotoQuickUploadView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoQuickUploadView.h"
#import "UIImage+WARBundleImage.h"
#import "UIColor+WARCategory.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARPhotosCollectionView.h"
#import "TZImageManager.h"
#import "WARImagePickerController.h"
#import "TZAssetModel.h"
#import "WARPhotoModel.h"
@implementation WARPhotoQuickUploadView

- (instancetype)initWithFrame:(CGRect)frame atWithSegementArr:(NSArray*)array atCompareArr:(NSArray*)compareArray{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cornerView];
        [self.cornerView addSubview:self.closeBtn];
  
   
        [self.cornerView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        
        }];
        
        self.closeBtn.frame = CGRectMake(0, 0, kScreenWidth, 30);
       [WARPhotoQuickUploadView drarectAngle:self corners:UIRectCornerTopRight|UIRectCornerTopLeft size:CGSizeMake(4, 4)];
            self.compareArr = compareArray;
            self.segmentCotrolArr = array;
         self.PhotosQView.photoArray = array;
    
        [self.cornerView addSubview:self.segmentControl];
        
        [self.cornerView addSubview:self.PhotosQView];
        [self.cornerView addSubview:self.tipsLb];
      
     
    }
    return self;
}

- (void)dealloc{
 
}
- (void)closeClick:(UIButton*)btn{

    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)gestureBegan:(WARPhotosQView *)collectionView tempview:(UIView *)tempView data:(id)modelData{
    
}
- (void)gestureChange:(WARPhotosQView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point data:(id)modelData{
    
      CGPoint Quickpoint =   [collectionView convertPoint:point toView:self];
    if ([self.delegate respondsToSelector:@selector(photoQuickUploadViewChange:point:gesture:data:isDraging:)]){
        
        [self.delegate photoQuickUploadViewChange:self point:Quickpoint gesture:nil data:modelData isDraging:[self.layer containsPoint:Quickpoint]];
    }
}
- (void)gestureEnd:(WARPhotosQView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point data:(id)modelData{

    CGPoint Quickpoint =   [collectionView convertPoint:point toView:self];

    
    if ([self.delegate respondsToSelector:@selector(photoQuicUploadViewEnd:point:gesture:data:isDraging:)]){
        [self.delegate photoQuicUploadViewEnd:self point:Quickpoint gesture:nil data:modelData isDraging:[self.layer containsPoint:Quickpoint]];
    }
}
- (void)segmentControl:(XTSegmentControl *)control selectedIndex:(NSInteger)index{
    
    [self.PhotosQView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)WARPhotosQView:(WARPhotosQView *)photoQView willDisplay:(NSInteger)sectionIndex{
  
    [self.segmentControl selectIndex:sectionIndex];
}

- (UIView *)cornerView{
    if (!_cornerView) {
        _cornerView = [[UIView alloc] init];
        _cornerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return _cornerView;
}
+ (void)drarectAngle:(UIView*)v corners:(UIRectCorner)corners size :(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, v.frame.size.height) byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, kScreenWidth,  v.frame.size.height);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowOffset = CGSizeMake(0, 1);
    v.layer.shadowOpacity = 1.5f;
    v.layer.shadowPath = maskPath.CGPath;
//    maskLayer.path = maskPath.CGPath;
//
//    v.layer.mask = maskLayer;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
       [_closeBtn setImage:[UIImage war_imageName:@"chat_gift_down" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
//        _closeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return _closeBtn;
}
- (XTSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.closeBtn.frame), kScreenWidth, 55) Items:self.segmentCotrolArr itemCompare:self.compareArr  delegate:self];
           [_segmentControl selectIndex:0];
    }
    return _segmentControl;
}
- (WARPhotosQView *)PhotosQView{
    
    if(!_PhotosQView){
        _PhotosQView = [[WARPhotosQView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), kScreenWidth, 127)];
        _PhotosQView.delegate = self;
    }
    return _PhotosQView;
}
- (UILabel *)tipsLb{
    if (!_tipsLb) {
        _tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.PhotosQView.frame), kScreenWidth-10, 35)];
        _tipsLb.text = WARLocalizedString(@"*拖动照片/视频到你的目标相册中");
        _tipsLb.font = kFont(11);
        _tipsLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _tipsLb;
}
@end
