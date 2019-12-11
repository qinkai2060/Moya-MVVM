//
//  SegmentControl.m
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import "XTSegmentControl.h"
#import "UIImage+WARBundleImage.h"
#import "WARPhotoModel.h"
#import "TZImageManager.h"
#define XTSegmentControlItemFont (15)

#define XTSegmentControlHspace (12)

#define XTSegmentControlLineHeight (3)

#define XTSegmentControlAnimationTime (0.3)

@interface XTSegmentControlItem : UIView

@property (nonatomic , strong) UIImageView *bgImageview;
@property (nonatomic , strong) UIImageView *maskV;
@property (nonatomic , strong) UILabel  *titlelb;
@property (nonatomic , strong) UILabel  *monthlb;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;
@property (nonatomic,strong) TZAssetModel *model;
@end

@implementation XTSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage*)image
{
    if (self = [super initWithFrame:frame]) {
        _bgImageview = ({
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            imgv.image = [UIImage war_imageName:@"picture_01" curClass:self curBundle:@"WARProfile.bundle"];
            imgv.contentMode = UIViewContentModeScaleAspectFill;
            imgv.layer.cornerRadius = 2;
            imgv.clipsToBounds = YES;
            imgv;

        });
        [self addSubview:_bgImageview];
        _maskV = ({
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            imgv.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            imgv.layer.cornerRadius = 2;
            imgv.tag = 100001;
            imgv.clipsToBounds = YES;
            imgv;
        });
        [_bgImageview addSubview:_maskV];
        _monthlb = ({
            UILabel *monthlb = [[UILabel alloc] initWithFrame:CGRectMake(0, 00, CGRectGetWidth(self.bounds), 20)];
            monthlb.textColor = [UIColor whiteColor];
            monthlb.textAlignment = NSTextAlignmentCenter;
            monthlb.font = [UIFont boldSystemFontOfSize:16];
            monthlb.text = title;
            monthlb;
        });
        [_bgImageview addSubview:_monthlb];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setModel:(TZAssetModel *)model{
    _model = model;
    self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:model.asset];
    int32_t imageRequestID = [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.frame.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
 
     
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:model.asset]]) {
            self.bgImageview.image = photo;
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
}

@end

@interface XTSegmentControl ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *contentView;

@property (nonatomic , strong) UIView *leftShadowView;

@property (nonatomic , strong) UIView *rightShadowView;

//@property (nonatomic , strong) UIImageView *lineView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , strong) NSMutableArray *itemsTitle;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic , assign) id <XTSegmentControlDelegate> delegate;

@property (nonatomic , copy) XTSegmentControlBlock block;

@end

@implementation XTSegmentControl

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem itemCompare:(NSArray*)compareArr
{
    if (self = [super initWithFrame:frame]) {
        
        _contentView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self addSubview:scrollView];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
            [scrollView addGestureRecognizer:tapGes];
            [tapGes requireGestureRecognizerToFail:scrollView.panGestureRecognizer];
            scrollView;
        });
    
        
        [self initItemsWithTitleArray:titleItem compare:compareArr];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem  itemCompare:(NSArray*)compareArr delegate:(id<XTSegmentControlDelegate>)delegate
{
    
    if (self = [self initWithFrame:frame Items:titleItem itemCompare:compareArr]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem  itemCompare:(NSArray*)compareArr selectedBlock:(XTSegmentControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem itemCompare:compareArr]) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)doTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        
        if (CGRectContainsPoint(rect, point)) {
            
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XTSegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray compare:(NSArray*)compareArr
{
    _itemFrames = @[].mutableCopy;
    _itemsTitle = @[].mutableCopy;
    [_itemsTitle addObjectsFromArray:titleArray];
    

    for (int i = 0; i < titleArray.count; i++) {


        float x = (i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0)+5;
        float y = 0;
        float width;
 
        width = 75;
   
      
        float height =50;
        CGRect rect = CGRectMake(x, y, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
    }
    
    for (int i = 0; i < titleArray.count; i++) {
        WARPhotoModel *photoModel = titleArray[i];
        CGRect rect = [_itemFrames[i] CGRectValue];
        NSString *monthStr = [photoModel.MothStr substringWithRange:NSMakeRange(5, 2)];
        NSString *YearStr =  [photoModel.MothStr substringWithRange:NSMakeRange(0, 4)];
        for (NSInteger i = 0; i < compareArr.count; i++) {
            WARPhotoSegementControlModel *segmentControlModel = compareArr[i];
            if ([YearStr isEqualToString:segmentControlModel.yearStr]) {
                WARPhotoModel *yearModel  =  [segmentControlModel.ModthArray lastObject];
                if ([photoModel.MothStr isEqualToString:yearModel.MothStr]) {
                    monthStr = [yearModel.MothStr substringWithRange:NSMakeRange(0, 4)];
                }
            }
        }
        TZAssetModel *asetmodel =   [photoModel.ModthArray firstObject];
        NSString *title = monthStr;
        XTSegmentControlItem *item = [[XTSegmentControlItem alloc] initWithFrame:rect title:title image:nil];
        item.model = asetmodel;
        item.tag=i;
        [_contentView addSubview:item];
    }

    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = 0;
    [self selectIndex:0];
    
    [self resetShadowView:_contentView];
}


- (void)selectIndex:(NSInteger)index
{
    if (index != _currentIndex) {
        
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect), CGRectGetHeight(rect) - XTSegmentControlLineHeight, 90, XTSegmentControlLineHeight);
        [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
        }];
        
        _currentIndex = index;
        
    }
    else {
        
    }
    if (_contentView.contentSize.width>_contentView.frame.size.width)
    {
        [self setScrollOffset:index];

    }
    for (UIView * item in _contentView.subviews)
    {
        if ([item isKindOfClass:[XTSegmentControlItem class]])
        {
            XTSegmentControlItem * itemcom=(XTSegmentControlItem *)item;
            if (item.tag==index)
            {
                itemcom.maskV.hidden = YES;
                
            }
            else
            {
                itemcom.maskV.hidden = NO;
                
            }
        }
    }
}

- (void)moveIndexWithProgress:(float)progress
{
    float delta = progress - _currentIndex;

    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + XTSegmentControlHspace, CGRectGetHeight(origionRect) - XTSegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
    
    CGRect rect;
    
    if (delta > 0) {
        
        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex + 1] CGRectValue];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        if (delta > 1) {
            
            _currentIndex ++;
        }
        
    }else if (delta < 0){
        
        if (_currentIndex == 0) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        if (delta < -1) {
            
            _currentIndex --;
        }
    }    
}

- (void)endMoveIndex:(NSInteger)index
{
    [self selectIndex:index];
}

- (void)setScrollOffset:(NSInteger)index
{
    CGRect rect = [_itemFrames[index] CGRectValue];

    float midX = CGRectGetMidX(rect);
    
    float offset = 0;
    
    float contentWidth = _contentView.contentSize.width;
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    
    [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
        [_contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resetShadowView:scrollView];
}

- (void)resetShadowView:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0) {
        
        _leftShadowView.hidden = NO;
        
        if (scrollView.contentOffset.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds)) {
            _rightShadowView.hidden = YES;
        }else{
            _rightShadowView.hidden = NO;
        }
        
    }else if (scrollView.contentOffset.x == 0) {
        _leftShadowView.hidden = YES;
        if (_contentView.contentSize.width < CGRectGetWidth(_contentView.frame)) {
            _rightShadowView.hidden = YES;
        }else{
            _rightShadowView.hidden = NO;
        }
    }
}
-(void)ReloadContentByArrys:(NSMutableArray *)arrys
{
    for (UIView * v in _contentView.subviews)
    {
        if ([v isKindOfClass:[XTSegmentControlItem class]])
        {
            [v removeFromSuperview];
        }
    }
}

@end

