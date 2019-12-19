//
//  HFUIkit.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import <AsyncDisplayKit/ASStackLayoutDefines.h>
#import <AsyncDisplayKit/ASButtonNode.h>
NS_ASSUME_NONNULL_BEGIN
@class HFTableViewnView;
@interface HFUIkit : HFView
+ (UILabel*)textColor:(NSString *)colorStr font:(CGFloat)font numberOfLines:(NSInteger)numberOfLines;
+ (UILabel*)textColor:(NSString *)colorStr blodfont:(CGFloat)font numberOfLines:(NSInteger)numberOfLines;

+ (UICollectionView*)minimumLineSpacing:(CGFloat)minimumLineSpacing minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing scrollDirection:(UICollectionViewScrollDirection)scrollDirection sectionInset:(UIEdgeInsets)edgeInsets itemSize:(CGSize)itemSize backgroundColor:(UIColor*)color delegate:(id)obj frame:(CGRect)frame;
+ (UITableView*)tableViewWith:(UITableViewStyle)style delegate:(id)delegate cellClass:(Class)classd Identifier:(NSString *)Identifier;
+ (HFTableViewnView*)hf_tableViewWith:(UITableViewStyle)style delegate:(id)delegate cellClass:(Class)classd Identifier:(NSString *)Identifier;
+ (UIPageControl*)pageIndicatorTintColor:(NSString*)color currentPageIndicatorTintColor:(NSString*)pageindicator;

+ (UIButton *)image:(NSString*)imageStr selectImage:(NSString*)imageSelectStr ;
+ (UIButton *)image:(NSString*)imageStr disableImag:(NSString*)imageDisableStr;
+ (UIButton *)btnWithfont:(CGFloat)font text:(NSString*)text titleColor:(NSString*)titleColor selectTitleColor:(NSString*)selectTitleColor;
+ (UIButton *)btnWithfont:(CGFloat)font text:(NSString*)text titleColor:(NSString*)titleColor  selectTitleColor:(NSString*)selectTitleColor disableColor:(NSString*)disableColor backGroundColor:(NSString*)bgColor;

+ (ASButtonNode *)nodeButtonNodeAddNode:(ASDisplayNode *)addNode Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(UIFont *)font CornerRadius:(CGFloat)cornerRadius BackgroundColor:(UIColor *)backgroundColor ContentVerticalAlignment:(ASVerticalAlignment)contentVerticalAlignment ContentHorizontalAlignment:(ASHorizontalAlignment)contentHorizontalAlignment;

+ (ASButtonNode *)nodeButtonNodeAddNode:(ASDisplayNode *)addNode Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(UIFont *)font Image:(UIImage *)image ImageAlignment:(ASButtonNodeImageAlignment)imageAlignment CornerRadius:(CGFloat)cornerRadius BackgroundColor:(UIColor *)backgroundColor ContentVerticalAlignment:(ASVerticalAlignment)contentVerticalAlignment ContentHorizontalAlignment:(ASHorizontalAlignment)contentHorizontalAlignment;


@end

NS_ASSUME_NONNULL_END
