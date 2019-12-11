//
//  WARFavoriteModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/16.
//

#import <Foundation/Foundation.h>
@class WARFavoriteInfoModel;
@interface WARFavoriteModel : NSObject
/**lastCreateTime*/
@property (nonatomic,assign) NSInteger lastCreateTime;
/**lastType*/
@property (nonatomic,copy) NSString  *lastType;
/**favorites*/
@property (nonatomic,copy) NSMutableArray<WARFavoriteInfoModel*>  *favorites;
@end
@interface WARFavoriteInfoModel: NSObject
/**favoriteCount*/
@property (nonatomic,copy) NSString  *favoriteCount;
/**favoriteCover*/
@property (nonatomic,copy) NSString  *favoriteCover;
/**favoriteId*/
@property (nonatomic,copy) NSString  *favoriteId;
/**favoriteName*/
@property (nonatomic,copy) NSString  *favoriteName;
/**favoriteType*/
@property (nonatomic,copy) NSString  *favoriteType;
/**permission*/
@property (nonatomic,copy) NSString  *permission;
@end
