//
//  WARSettingFooterView.h
//  Pods
//
//  Created by huange on 2017/8/4.
//
//

#import <UIKit/UIKit.h>

@protocol WARUserSettingFooterViewDelegate <NSObject>

-(void)clickButtonAction;

@end

@interface WARUserSettingFooterView : UIView

@property (nonatomic, weak) id <WARUserSettingFooterViewDelegate> delegate;
@property (nonatomic, assign) BOOL buttonEnable;

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString*)title;

@end
