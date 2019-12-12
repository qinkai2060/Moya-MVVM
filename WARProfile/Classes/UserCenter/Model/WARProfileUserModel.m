//
//  WARProfileUserModel.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/11.
//

#import "WARProfileUserModel.h"
#import "YYModel.h"
#import "WARMacros.h"
@implementation WARProfileUserModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"masks" : [WARProfileMasksModel class]};
}

- (void)praseData:(id)obj {
    
    NSDictionary *dict = (NSDictionary*)obj;
    self.accNum = [WARProfileUserModel EmptyCheckobjnil:dict[@"accNum"]];
    self.accountId = [WARProfileUserModel EmptyCheckobjnil:dict[@"accountId"]];
    
    if ([dict[@"masks"] isKindOfClass:[NSArray class]]) {
        NSArray *masksArr= [WARProfileUserModel EmptyCheckobjnil:dict[@"masks"]];
        
        NSMutableArray *maskArr = [NSMutableArray array];
        for (NSDictionary *dict in masksArr) {
        WARProfileMasksModel *maskModel = [[WARProfileMasksModel alloc] init];
            NSMutableString *strAppendYearMD = [NSMutableString string];
            
            NSMutableArray *userInfoDetailArr = [NSMutableArray array];
            NSMutableArray *tagArray  =  [NSMutableArray array];
            maskModel.year      =  [WARProfileUserModel EmptyCheckobjnil:[NSString stringWithFormat:@"%ld ",[dict[@"year"] integerValue]]];
            maskModel.month     =  [WARProfileUserModel EmptyCheckobjnil:[NSString stringWithFormat:@"%ld ",[dict[@"month"] integerValue]]];
            maskModel.day       =  [WARProfileUserModel EmptyCheckobjnil:[NSString stringWithFormat:@"%ld ",[dict[@"day"] integerValue]]];
            maskModel.maskId    =  [WARProfileUserModel EmptyCheckobjnil:dict[@"maskId"]];
            maskModel.faceImg   =  [WARProfileUserModel EmptyCheckobjnil:dict[@"faceImg"]];
            maskModel.signature =  [WARProfileUserModel EmptyCheckobjnil:dict[@"signature"]];
            maskModel.faceId    =  [WARProfileUserModel EmptyCheckobjnil:dict[@"faceId"]];
            maskModel.nickname  =  [WARProfileUserModel EmptyCheckobjnil:dict[@"nickname"]];
            maskModel.bgId      =  [WARProfileUserModel EmptyCheckobjnil:dict[@"bgId"]];
            maskModel.gender    =  [WARProfileUserModel EmptyCheckobjnil:dict[@"gender"]];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if([key isEqualToString:@"year"]||[key isEqualToString:@"month"]||[key isEqualToString:@"day"]){
                    
                    [strAppendYearMD appendString:[NSString stringWithFormat:@"%ld ",[obj integerValue]]];
                     maskModel.bornDay = strAppendYearMD;
                }
                WARProfileUserMasksModel *userMaskModel = [self dataBuildWithKey:key atObj:obj];
                if (userMaskModel != nil) {
                    [userInfoDetailArr addObject:userMaskModel];
                }

                if ([key isEqualToString:@"delicacies"]||[key isEqualToString:@"sports"]||[key isEqualToString:@"tourisms"]||[key isEqualToString:@"books"]||[key isEqualToString:@"films"]||[key isEqualToString:@"musics"]||[key isEqualToString:@"others"]) {
                    [tagArray addObjectsFromArray:[WARProfileUserModel EmptyCheckobjnil:obj]];
                }
                
            }];
            
            NSArray *newArr = [self sortNewArr:userInfoDetailArr type:1];
            NSMutableArray *tempArr = [NSMutableArray array];
            NSMutableArray *arrInfo = [NSMutableArray arrayWithArray:newArr];
            maskModel.interestsArr = tagArray.copy;
            maskModel.userInfoArr  = [self targetArr:arrInfo tempArray:tempArr];
            [maskArr addObject:maskModel];
        }
        self.MasksArr = maskArr.copy;
    }

}
- (NSArray*)targetArr:(NSMutableArray*)arrInfo tempArray:(NSMutableArray*)tempArr {
    for (WARProfileUserMasksModel *model in arrInfo) {
        if ([model.name isEqualToString:@"家乡"]) {
            [tempArr addObject:model];
        }
    }
    NSArray *newTempArr =   [self sortNewArr:tempArr type:2];
    
    if (newTempArr.count >= 2) {
        
        NSMutableString *strAppend = [NSMutableString string];
        for (WARProfileUserMasksModel *model in newTempArr) {
            [strAppend appendString:model.detailInfoStr];
        }
        for (int i = 0; i<newTempArr.count; i++) {
            [arrInfo removeObjectAtIndex:0];
        }
        
        
        WARProfileUserMasksModel *newModel = [[WARProfileUserMasksModel alloc] init];
        newModel.name = @"家乡";
        newModel.detailInfoStr = strAppend.copy;
        [arrInfo insertObject:newModel atIndex:0];
    }
    return arrInfo.copy;
}
- (NSArray*)sortNewArr:(NSArray*)tempArray type:(NSInteger)type {
    if (type == 1) {
        return     [tempArray  sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            WARProfileUserMasksModel *model1 = obj1;
            WARProfileUserMasksModel *model2 = obj2;
            return model1.sort > model2.sort;
        }];
    }else{
       return [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            WARProfileUserMasksModel *model1 = obj1;
            WARProfileUserMasksModel *model2 = obj2;
            return model1.provicesort >model2.provicesort;
        }];
    }
   
}
- (WARProfileUserMasksModel *)dataBuildWithKey:(id)key atObj:(id)obj {
    
   
    if ([key isEqualToString:@"province"]||[key isEqualToString:@"city"]) {
        return   [self userinfoDataBuildWithKey:key atObj:obj atTypeName:@"家乡" atSort:1 atProvinceSort:0];
    }
    
    if ([key isEqualToString:@"industry"]) {
     
        return [self userinfoDataBuildWithKey:key atObj:obj atTypeName:@"行业" atSort:2 atProvinceSort:0];
        
    }
    if ([key isEqualToString:@"job"]) {

        return [self userinfoDataBuildWithKey:key atObj:obj atTypeName:@"职业" atSort:3 atProvinceSort:0];
    }
    if ([key isEqualToString:@"affectiveState"]) {
  
        return [self userinfoDataBuildWithKey:key atObj:[WARProfileUserModel affectiveState:obj] atTypeName:@"情感状态" atSort:4 atProvinceSort:0];
        
    }
    if ([key isEqualToString:@"school"]) {

      return [self userinfoDataBuildWithKey:key atObj:obj atTypeName:@"学校" atSort:5 atProvinceSort:0];
    }
    if ([key isEqualToString:@"company"]) {

       return [self userinfoDataBuildWithKey:key atObj:obj atTypeName:@"公司" atSort:6 atProvinceSort:0];
    }
    
    return nil;
}
- (WARProfileUserMasksModel*)userinfoDataBuildWithKey:(id)key atObj:(id)obj atTypeName:(NSString*)name atSort:(NSInteger)sort atProvinceSort:(NSInteger)provinsort{
        WARProfileUserMasksModel *masksModel = [[WARProfileUserMasksModel alloc] init];
        masksModel.name = name;
        masksModel.detailInfoStr = [WARProfileUserModel EmptyCheckobjnil:obj] ;
        masksModel.sort = sort;
        if ([key isEqualToString:@"province"]) {
            masksModel.provicesort = 1;
        }else{
            masksModel.provicesort = 2;
        }
        
        return masksModel;
}
+ (NSString*)affectiveState:(id)obj {
   // SECRECY, //保密 SINGLE, //单身 IN_LOVE, //恋爱中 MARRIED, //已婚
    if ([[WARProfileUserModel EmptyCheckobjnil:obj] isEqualToString:@"SECRECY"]) {
        return @"保密";
    }else if ([[WARProfileUserModel EmptyCheckobjnil:obj] isEqualToString:@"SINGLE"])
    {
         return @"单身";
    }
    else if ([[WARProfileUserModel EmptyCheckobjnil:obj] isEqualToString:@"IN_LOVE"])
    {
        return @"恋爱中";
    }
    else if ([[WARProfileUserModel EmptyCheckobjnil:obj] isEqualToString:@"MARRIED"])
    {
        return @"已婚";
    }else{
        return @"";
    }
}
+ (id)EmptyCheckobjnil:(id)obj {

    if ([obj isEqual:[NSNull null]]) {
        return @"";
    }  else if (obj==nil) {
        return @"";
    }  else {
        return obj;
    }
}
@end
@implementation WARProfileMasksModel
@end
@implementation WARProfileUserMasksModel
- (instancetype)initWithName:(NSString *)name tags:(NSArray *)tags {
    if (self = [super init]) {
        self.name = name;
        self.tags = tags;
        self.height = [WARProfileUserMasksModel heightForCell:self];
    }
    return self;
}
+ (instancetype)name:(NSString *)name tags:(NSArray *)tags {
    return [[self alloc] initWithName:name tags:tags];
}
- (instancetype)initWithName:(NSString *)name content:(NSString *)content {
    if (self = [super init]) {
        self.name = name;
        self.detailInfoStr = WARLocalizedString(content);
        self.height = [WARProfileUserMasksModel heighttextForCell:self];
    }
    return self;
}
+ (instancetype)name:(NSString *)name content:(NSString *)content {
     return [[self alloc] initWithName:name content:content];
}
+(CGFloat)heightForCell:(WARProfileUserMasksModel*)model {
    CGFloat lbtop = 18;
    CGFloat H = 0;
    CGRect frame;
    CGFloat MAXW = kScreenWidth - 15 -14-32-56;
    
    for (int i = 0; i < model.tags.count; i++) {
        CGRect rect = [model.tags[i] boundingRectWithSize:CGSizeMake(MAXW , 22) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat BtnW = rect.size.width+12;
        CGFloat BtnH = rect.size.height + 6;
        
        if (i == 0) {
            H += BtnH;
            frame =CGRectMake(0, 0, BtnW, BtnH);
            
        }else {
            CGFloat yuWidth = MAXW  - frame.origin.x -frame.size.width;
            
            
            if (yuWidth >= BtnW) {
                
                frame = CGRectMake(frame.origin.x +frame.size.width + 8,frame.origin.y, BtnW, BtnH);
            }else{
                
                frame =CGRectMake(0, frame.origin.y+frame.size.height+8, BtnW, BtnH);
                H += (BtnH+8);
            }
            
        }
    }
    
    return lbtop+H+5;
    
}
+(CGFloat)heighttextForCell:(WARProfileUserMasksModel*)model {
    CGFloat lbtop = 18;
    CGFloat MAXW = kScreenWidth - 99 - 15;
    CGRect rect = [model.detailInfoStr boundingRectWithSize:CGSizeMake(MAXW , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    CGFloat maxH = MAX(16, rect.size.height);
    return lbtop+maxH;
    
}
@end

@implementation WARProfileUserSettingModel

@end
