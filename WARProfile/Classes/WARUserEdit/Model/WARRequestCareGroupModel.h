//
//  WARRequestCareGroupModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/16.
//

#import <Foundation/Foundation.h>

@interface WARRequestCareGroupModel : NSObject
@property(nonatomic,copy)NSString *categoryId;
@property(nonatomic,copy)NSString *maskId;
@property(nonatomic,copy)NSString *name;// 修改后的名字categoryname
@property(nonatomic,copy)NSString *operateType;

+ (NSArray*)prase:(NSArray *)categoryArr;
@end
