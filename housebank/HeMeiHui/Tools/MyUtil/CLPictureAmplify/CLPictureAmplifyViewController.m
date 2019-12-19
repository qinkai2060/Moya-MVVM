//
//  CLPictureAmplifyViewController.m
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "CLPictureAmplifyViewController.h"
#import "pictureCell.h"
#import "SaveImageToAlbumTool.h"


static NSString *ID = @"cell";

@interface CLPictureAmplifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) UILabel *textlable;

@property (nonatomic,assign) CGFloat totalScale;

@end

@implementation CLPictureAmplifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.totalScale = 1.0;
    
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    // 创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-100);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView registerNib:[UINib nibWithNibName:@"pictureCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.touchIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    self.textlable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 20)];
    self.textlable.text = [NSString stringWithFormat:@"%ld/%ld",self.touchIndex+1,self.picArray.count];
    self.textlable.textAlignment  =NSTextAlignmentCenter;
    self.textlable.textColor = [UIColor whiteColor];
    self.textlable.font = [UIFont systemFontOfSize:16];
    
    if (!self.hiddenTextLable) {
        [self.view addSubview:self.textlable];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    pictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.picImg = self.picArray[indexPath.row];
    cell.clickCellImage = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    cell.longPressImage = ^{
        if (self.picUrlArray.count > indexPath.row) {
            [SaveImageToAlbumTool svaeImageToassetCollectionName:@"合发" formUrl:self.picUrlArray[indexPath.row]];
        }
    };
    cell.doubleTap = ^(UIPinchGestureRecognizer *pinchGes) {
        [self didDoubleTap:pinchGes];
    };
//    cell.panTap = ^(UIPanGestureRecognizer *panGes) {
//        [self handlePan:panGes];
//    };
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.picArray.count;
    self.textlable.text = [NSString stringWithFormat:@"%d/%ld",page+1,self.picArray.count];
}

#pragma mark ----------- 缩放手势响应事件
- (void)didDoubleTap:(UIPinchGestureRecognizer *)pinchGes{
    CGFloat lastScale = [pinchGes scale];
    UIView *view = pinchGes.view;

    //放大情况
    if(lastScale >= 1.0){
        if(self.totalScale > 5) return;
    }
    //缩小情况
    if (lastScale < 1.0) {
        if (self.totalScale < 0.5) return;
    }
    if (pinchGes.state == UIGestureRecognizerStateBegan || pinchGes.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGes.scale, pinchGes.scale);
        self.totalScale *= lastScale;

        pinchGes.scale = 1;
    }
    //当手指离开屏幕时,将lastscale设置为1.0
    if([pinchGes state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
}

//#pragma mark ----------- 移动手势响应事件
//- (void)handlePan:(UIPanGestureRecognizer *)panGes{
//
//    UIView *view = panGes.view;
//    if (panGes.state == UIGestureRecognizerStateBegan || panGes.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [panGes translationInView:view.superview];
//        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
//        [panGes setTranslation:CGPointZero inView:view.superview];
//    }
//}

@end
