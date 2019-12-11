//
//  WARProfileCoverLayout.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/16.
//

#import <UIKit/UIKit.h>
typedef void(^didScrollAt)(NSInteger index);
@interface WARProfileCoverLayout : UICollectionViewFlowLayout
@property (nonatomic,copy) didScrollAt scrollDidBlock;
@end
