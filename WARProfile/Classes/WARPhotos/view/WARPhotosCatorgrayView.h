//
//  WARPhotosCatorgrayView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import <UIKit/UIKit.h>
@class WARPhotosCatorgrayView;
@protocol WARPhotosCatorgrayViewDelegate <NSObject>

@optional
- (void)photosCatorgrayView:(WARPhotosCatorgrayView*)photosCatorgayView didSelectIndex:(NSInteger)index;

@end

@interface WARPhotosCatorgrayView : UIView
/**相册*/
@property (nonatomic,strong) UIButton *photoBtn;
/**照片*/
@property (nonatomic,strong) UIButton *albumBtn;
/**视频*/
@property (nonatomic,strong) UIButton *videoBtn;
/**间隔view*/
@property (nonatomic,strong) UIView *firstView;
/**间隔view*/
@property (nonatomic,strong) UIView *secondView;
/**代理*/
@property (nonatomic,weak) id<WARPhotosCatorgrayViewDelegate> delegate;

@property(nonatomic,strong)UIButton *selectBtn;
@end
