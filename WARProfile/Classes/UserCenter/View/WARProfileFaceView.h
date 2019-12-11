//
//  WARProfileFaceView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/16.
//

#import <UIKit/UIKit.h>
@class WARProfileFaceView;
@protocol WARProfileFaceViewDelegate <NSObject>
- (void)faceView:(WARProfileFaceView*)faceView didShowItemAtIndex:(NSInteger)itemIndex;
@end

typedef void (^WARProfileFaceViewCellLongPressBlock) (NSInteger index);

@interface WARProfileFaceView : UIView
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,weak) id<WARProfileFaceViewDelegate> delegate;

@property (nonatomic, copy) WARProfileFaceViewCellLongPressBlock longPressBlock;

- (void)scrollToIndex:(NSInteger)index;

@end
