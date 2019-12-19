//
//  HFUIkit.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFUIkit.h"
#import "HFTableViewnView.h"
@implementation HFUIkit
+ (UILabel*)textColor:(NSString *)colorStr font:(CGFloat)font numberOfLines:(NSInteger)numberOfLines {
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor colorWithHexString:colorStr];
    lb.font = [UIFont systemFontOfSize:font];
    lb.numberOfLines = numberOfLines;
    return lb;
}
+ (UILabel*)textColor:(NSString *)colorStr blodfont:(CGFloat)font numberOfLines:(NSInteger)numberOfLines{
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor colorWithHexString:colorStr];
    lb.font = [UIFont boldSystemFontOfSize:font];
    lb.numberOfLines = numberOfLines;
    return lb;
}
+ (UICollectionView*)minimumLineSpacing:(CGFloat)minimumLineSpacing minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing scrollDirection:(UICollectionViewScrollDirection)scrollDirection sectionInset:(UIEdgeInsets)edgeInsets itemSize:(CGSize)itemSize backgroundColor:(UIColor*)color delegate:(id)obj frame:(CGRect)frame
{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    flowLayout.scrollDirection = scrollDirection;
    flowLayout.sectionInset = edgeInsets;
    flowLayout.itemSize = itemSize;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = color;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = obj;
    collectionView.dataSource = obj;
    
    return collectionView;
}
+ (UIPageControl*)pageIndicatorTintColor:(NSString*)color currentPageIndicatorTintColor:(NSString*)pageindicator {
  UIPageControl  *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:color];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:pageindicator];
    return pageControl;

}
+ (UITableView*)tableViewWith:(UITableViewStyle)style delegate:(id)delegate cellClass:(Class)classd Identifier:(NSString *)Identifier {
    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tab.delegate = delegate;
    tab.dataSource = delegate;
    [tab registerClass:classd forCellReuseIdentifier:Identifier];
    return tab;
}
+ (HFTableViewnView*)hf_tableViewWith:(UITableViewStyle)style delegate:(id)delegate cellClass:(Class)classd Identifier:(NSString *)Identifier {
    HFTableViewnView *tab = [[HFTableViewnView alloc] initWithFrame:CGRectZero style:style];
    tab.delegate = delegate;
    tab.dataSource = delegate;
    [tab registerClass:classd forCellReuseIdentifier:Identifier];
    return tab;
}
+ (UIButton *)image:(NSString*)imageStr selectImage:(NSString*)imageSelectStr  {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageSelectStr] forState:UIControlStateSelected];
    return btn;
}
+ (UIButton *)image:(NSString*)imageStr disableImag:(NSString*)imageDisableStr  {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageDisableStr] forState:UIControlStateDisabled];
    return btn;
}
+ (UIButton *)btnWithfont:(CGFloat)font text:(NSString*)text titleColor:(NSString*)titleColor selectTitleColor:(NSString*)selectTitleColor{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:selectTitleColor] forState:UIControlStateSelected];
    return btn;
    
}
+ (UIButton *)btnWithfont:(CGFloat)font text:(NSString*)text titleColor:(NSString*)titleColor  selectTitleColor:(NSString*)selectTitleColor disableColor:(NSString*)disableColor backGroundColor:(NSString*)bgColor{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:selectTitleColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithHexString:disableColor] forState:UIControlStateDisabled];
    btn.backgroundColor = [UIColor colorWithHexString:bgColor];
    return btn;
}
+ (ASButtonNode *)nodeButtonNodeAddNode:(ASDisplayNode *)addNode Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(UIFont *)font CornerRadius:(CGFloat)cornerRadius BackgroundColor:(UIColor *)backgroundColor ContentVerticalAlignment:(ASVerticalAlignment)contentVerticalAlignment ContentHorizontalAlignment:(ASHorizontalAlignment)contentHorizontalAlignment{
    
    ASButtonNode *buttonNode = [ASButtonNode new];
    buttonNode.backgroundColor = backgroundColor;
    if (title) {
        [buttonNode setTitle:title withFont:font withColor:titleColor forState:UIControlStateNormal];
    }
    buttonNode.contentVerticalAlignment = contentVerticalAlignment;
    buttonNode.contentHorizontalAlignment = contentHorizontalAlignment;
    buttonNode.cornerRadius = cornerRadius;

    return buttonNode;
    
}

+ (ASButtonNode *)nodeButtonNodeAddNode:(ASDisplayNode *)addNode Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(UIFont *)font Image:(UIImage *)image ImageAlignment:(ASButtonNodeImageAlignment)imageAlignment CornerRadius:(CGFloat)cornerRadius BackgroundColor:(UIColor *)backgroundColor ContentVerticalAlignment:(ASVerticalAlignment)contentVerticalAlignment ContentHorizontalAlignment:(ASHorizontalAlignment)contentHorizontalAlignment{
    
    ASButtonNode *buttonNode = [ASButtonNode new];
    buttonNode.backgroundColor = backgroundColor;
    if (title) {
        [buttonNode setTitle:title withFont:font withColor:titleColor forState:UIControlStateNormal];
    }
    if (image) {
        [buttonNode setImage:image forState:UIControlStateNormal];
    }
    [buttonNode setImageAlignment:imageAlignment];
    buttonNode.contentVerticalAlignment = contentVerticalAlignment;
    buttonNode.contentHorizontalAlignment = contentHorizontalAlignment;
    buttonNode.cornerRadius = cornerRadius;
    
    return buttonNode;
    
}

@end
