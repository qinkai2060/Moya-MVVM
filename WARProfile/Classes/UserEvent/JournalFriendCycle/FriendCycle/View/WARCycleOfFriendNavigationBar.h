//
//  WARCycleOfFriendNavigationBar.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/10.
//

#import <UIKit/UIKit.h>


typedef void(^WARCycleOfFriendNavigationBarDidBlock)(void);

@interface WARCycleOfFriendNavigationBar : UIView

@property(nonatomic,copy) WARCycleOfFriendNavigationBarDidBlock didLeftItemBlcok;
@property(nonatomic,copy) WARCycleOfFriendNavigationBarDidBlock didRightItemBlcok;
@property(nonatomic,copy) WARCycleOfFriendNavigationBarDidBlock didBarBlock;
@property(nonatomic,copy) WARCycleOfFriendNavigationBarDidBlock didTitleBlock;
@property(nonatomic,copy) WARCycleOfFriendNavigationBarDidBlock didFilterBlock;

- (void)scrollWithScale:(CGFloat)scale fontScale:(CGFloat)fontScale changeAlpha:(BOOL)changeAlpha;

@end
