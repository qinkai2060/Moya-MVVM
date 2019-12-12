//
//  WARTagCollectionView.h
//  WARProfile
//
//  Created by Hao on 2018/6/19.
//

#import <UIKit/UIKit.h>

@class WARTagCollectionView;

/**
 * Tags scroll direction
 */
typedef NS_ENUM(NSInteger, WARTagCollectionScrollDirection) {
    WARTagCollectionScrollDirectionVertical = 0, // Default
    WARTagCollectionScrollDirectionHorizontal = 1
};

/**
 * Tags alignment
 */
typedef NS_ENUM(NSInteger, WARTagCollectionAlignment) {
    WARTagCollectionAlignmentLeft = 0,             // Default
    WARTagCollectionAlignmentCenter,               // Center
    WARTagCollectionAlignmentRight,                // Right
    WARTagCollectionAlignmentFillByExpandingSpace, // Expand horizontal spacing and fill
    WARTagCollectionAlignmentFillByExpandingWidth  // Expand width and fill
};

/**
 * Tags delegate
 */
@protocol WARTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(WARTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (BOOL)tagCollectionView:(WARTagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(WARTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(WARTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end

/**
 * Tags dataSource
 */
@protocol WARTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(WARTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(WARTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end

@interface WARTagCollectionView : UIView
@property (nonatomic, weak) id <WARTagCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id <WARTagCollectionViewDelegate> delegate;

// Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// Tags scroll direction, default is vertical.
@property (nonatomic, assign) WARTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) WARTagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;

// Horizontal and vertical space between tags, default is 4.
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

// Manual content height
// Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
// Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

// Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/**
 * Reload all tag cells
 */
- (void)reload;

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
- (NSInteger)indexOfTagAt:(CGPoint)point;

@end
