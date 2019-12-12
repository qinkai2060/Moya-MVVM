//
//  WARPhotosCollectionView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import "WARPhotosCollectionView.h"
#import "WARPhotosCollectionCell.h"
@interface WARPhotosCollectionView ()
@property (nonatomic, strong) UILongPressGestureRecognizer *gesture;

@property (nonatomic, strong) UIView *tempView;

@property (nonatomic, strong) NSMutableArray *tempDataSource;
@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;
@end
@implementation WARPhotosCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
          [self initData];
    }
    return self;
}
- (void)initData{
    _gestureMinimumPressDuration = 0.2f;
    _canEdgeScroll = YES;
    _edgeScrollRange = 150.f;
    _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processGesture:)];
    _gesture.minimumPressDuration = _gestureMinimumPressDuration;
    [self addGestureRecognizer:_gesture];
}
- (void)processGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state){
        case UIGestureRecognizerStateBegan:
        {
            [self jx_gestureBegan:gesture];
        }
        break;
        case UIGestureRecognizerStateChanged:
        {
            
               [self jx_gestureChanged:gesture];
       
        }
        break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
           [self gestureEndedOrCancelled:gesture];
        }
        break;
    }
}
- (void)jx_gestureBegan:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *selectedIndexPath = [self indexPathForItemAtPoint:point];
    if (!selectedIndexPath) {
        return;
    }
    
    _selectedIndexPath = selectedIndexPath;
    // 代理
    WARPhotosCollectionCell *cell = [self cellForItemAtIndexPath:selectedIndexPath];
    
    _tempView = [self jx_snapshotViewWithInputView:cell];
    _tempView.backgroundColor = [UIColor redColor];
    _tempView.layer.shadowColor = [UIColor redColor].CGColor;
    _tempView.layer.masksToBounds = NO;
    _tempView.layer.cornerRadius = 0;
    _tempView.layer.shadowOffset = CGSizeMake(-5, 0);
    _tempView.layer.shadowOpacity = 0.4;
    _tempView.layer.shadowRadius = 5;
   _tempView.frame = cell.frame;
    [self.superview addSubview: _tempView];


    
    if ([self.delegate respondsToSelector:@selector(gestureBegan:tempview:)]) {
        [self.delegate gestureBegan:self tempview:_tempView];
    }
}
- (void)jx_gestureChanged:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view.superview];
    
     _tempView.center = CGPointMake(point.x,point.y);
        WARPhotosCollectionCell *cell = [self cellForItemAtIndexPath:_selectedIndexPath];
    if ([self.delegate respondsToSelector:@selector(gestureChange:tempview:point:)]) {
        [self.delegate gestureChange:self tempview:_tempView point:point];
    }
}
- (void)gestureEndedOrCancelled:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view.superview];
    // 
    WARPhotosCollectionCell *cell = [self cellForItemAtIndexPath:_selectedIndexPath];
    if ([self.delegate respondsToSelector:@selector(gestureEnd:tempview:point:atCell:)]) {
        [self.delegate gestureEnd:self tempview:_tempView point:point atCell:cell];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _tempView.alpha = 0;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [_tempView removeFromSuperview];
        _tempView = nil;
    }];
}
- (UIView *)jx_snapshotViewWithInputView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}
@end
