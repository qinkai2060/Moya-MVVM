//
//  WARHorizontalFlowLayout.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import <UIKit/UIKit.h>


@protocol  WARHorizontalFlowLayoutDelegate<NSObject>
-(void)scrolledToTheCurrentItemAtIndex:(NSInteger)itemIndex;
@end

@interface WARHorizontalFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<WARHorizontalFlowLayoutDelegate>  layoutDelegate;



@end
