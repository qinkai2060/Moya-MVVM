//
//  WARRewordView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

#import <UIKit/UIKit.h>
@class WARMomentReword;

@interface WARRewordView : UIView

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;
/** tipLable */
@property (nonatomic, strong) UILabel *valueLable;

- (void)configReword:(WARMomentReword *)reword;

- (UIImage *)currentViewImage;
- (UIImageView *)currentImageInView;

@end
