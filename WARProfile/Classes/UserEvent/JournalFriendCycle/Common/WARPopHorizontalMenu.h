//
//  WARPopHorizontalMenu.h
//  WARPopHorizontalMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  WARPopHorizontalMenuDoneBlock
 */
typedef void (^WARPopHorizontalMenuDoneBlock)(NSInteger selectedIndex);
/**
 *  WARPopHorizontalMenuDismissBlock
 */
typedef void (^WARPopHorizontalMenuDismissBlock)(void);

/**
 *  -----------------------WARPopHorizontalMenuConfiguration-----------------------
 */
@interface WARPopHorizontalMenuConfiguration : NSObject

@property (nonatomic, assign)CGFloat menuTextMargin;// Default is 6.
@property (nonatomic, assign)CGFloat menuIconMargin;// Default is 6.
@property (nonatomic, assign)CGFloat menuRowHeight;
@property (nonatomic, assign)CGFloat menuWidth;
@property (nonatomic, strong)UIColor *textColor;
@property (nonatomic, strong)UIColor *tintColor;
@property (nonatomic, strong)UIColor *borderColor;
@property (nonatomic, assign)CGFloat borderWidth;
@property (nonatomic, strong)UIFont *textFont;
@property (nonatomic, assign)NSTextAlignment textAlignment;
@property (nonatomic, assign)BOOL ignoreImageOriginalColor;// Default is 'NO', if sets to 'YES', images color will be same as textColor.
@property (nonatomic, assign)BOOL allowRoundedArrow;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
@property (nonatomic, assign)NSTimeInterval animationDuration;
@property (nonatomic, assign) BOOL needArrow; //default is YES
/**
 *  defaultConfiguration
 *
 *  @return curren configuration
 */
+ (WARPopHorizontalMenuConfiguration *)defaultConfiguration;

@end

/**
 *  -----------------------WARPopHorizontalMenuCell-----------------------
 */
@interface WARPopHorizontalMenuCell : UICollectionViewCell
//-(void)setupWithMenuImage:(id )menuImage;
-(void)setupWithMenuImage:(id )menuImage title:(NSString *)title;
@end
/**
 *  -----------------------WARPopHorizontalMenuView-----------------------
 */
@interface WARPopHorizontalMenuView : UIControl

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(void);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);

@end

/**
 *  -----------------------WARPopHorizontalMenu-----------------------
 */
@interface WARPopHorizontalMenu : NSObject

/**
 show method with SenderFrame and image resouce Array

 @param senderFrame senderFrame 
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame 
                  imageArray:(NSArray *)imageArray
                   doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
                dismissBlock:(WARPopHorizontalMenuDismissBlock)dismissBlock;


+ (void) showFromSenderFrame:(CGRect )senderFrame
                  imageArray:(NSArray *)imageArray
                  titleArray:(NSArray *)titleArray
                   doneBlock:(WARPopHorizontalMenuDoneBlock)doneBlock
                dismissBlock:(WARPopHorizontalMenuDismissBlock)dismissBlock;

/**
 *  dismiss method
 */
+ (void) dismiss;

@end
