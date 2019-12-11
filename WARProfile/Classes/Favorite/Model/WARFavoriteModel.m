//
//  WARFavoriteModel.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/16.
//

#import "WARFavoriteModel.h"

@implementation WARFavoriteModel
　　+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    　　 return @{@"favorites":[WARFavoriteInfoModel class]};
    　}
- (NSMutableArray<WARFavoriteInfoModel *> *)favorites {
    if (!_favorites) {
        _favorites = [NSMutableArray array];
    }
    return _favorites;
}
@end
@implementation WARFavoriteInfoModel

@end
