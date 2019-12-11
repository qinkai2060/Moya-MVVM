//
//  WARPhotoDetailEditingView.h
//  WARProduct
//
//  Created by 秦恺 on 2018/3/22.
//

#import <UIKit/UIKit.h>
@class WARPhotoDetailEditingView;
@protocol WARPhotoDetailEditingViewDelegate<NSObject>
- (void)photoDetailEditingView:(WARPhotoDetailEditingView*)photoDetailEditingView WithTagindex:(NSInteger)tagindex;
@end
@interface WARPhotoDetailEditingView : UIView
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)titleArray;
@property(nonatomic,weak)id<WARPhotoDetailEditingViewDelegate> delegate;
@property(nonatomic,strong)UIView *lineV;
@end
