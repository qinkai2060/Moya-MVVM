//
//  WARTagAddView.h
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "ReactiveObjC.h"

@protocol WARTagAddViewDelegate;

@interface WARTagAddView : UICollectionReusableView

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id <WARTagAddViewDelegate> delegate;
@property (nonatomic, strong) UIView *topLine;

@end


@protocol WARTagAddViewDelegate <NSObject>

- (void)addButtonAction:(NSString*)tagText;

@end
