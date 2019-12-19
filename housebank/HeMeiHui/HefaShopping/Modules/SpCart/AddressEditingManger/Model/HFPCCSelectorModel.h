//
//  HFPCCSelectorModel.h
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSInteger,HFPCCSelectorModelType) {
    HFPCCSelectorModelTypeCrown = 1,
    HFPCCSelectorModelTypeProvince = 2,
};
@interface HFPCCSelectorModel : NSObject
@property (nonatomic,copy) NSString *str;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSArray *areas;
@property (nonatomic,copy) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger provinceRow;
@property (nonatomic,assign) NSInteger cityRow;
@property (nonatomic,assign) NSInteger countyRow;
@property (nonatomic,assign) NSInteger FourRow;
@property (nonatomic,assign) HFPCCSelectorModelType contenMode;

@property (nonatomic,assign) NSInteger ids;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *shortName;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,copy) NSArray  *subArray;
@property (nonatomic,copy) NSString  *cityCode;
- (void)getData:(NSDictionary*)obj;
@end

NS_ASSUME_NONNULL_END
