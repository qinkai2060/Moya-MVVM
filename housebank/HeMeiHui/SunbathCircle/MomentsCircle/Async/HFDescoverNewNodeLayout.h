//
//  HFDescoverNewNodeLayout.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFDescoverNewNodeLayout : NSObject<ASCollectionLayoutDelegate,ASCollectionViewLayoutInspecting>
- (instancetype)initWithNumbers:(NSInteger)columnCount columnSpacing:(CGFloat)columnSpacing interItemSpace:(CGFloat)interItemSpace sectionInset:(UIEdgeInsets)sectionInset direction:(ASScrollDirection)direction ;
@end

NS_ASSUME_NONNULL_END
