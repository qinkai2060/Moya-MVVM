//
//  WARCategoryViewModel.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"

@interface WARCategoryViewModel : NSObject
// 获取分组下的人
@property (nonatomic, strong) RACCommand *getContactsForCategoryCommand;
// 编辑分组
@property (nonatomic, strong) RACCommand *updateCategoryCommand;
// 分组修改名称
@property (nonatomic, strong) RACCommand *updateCategoryNameCommand;
// 新建分组
@property (nonatomic, strong) RACCommand *createCategoryCommand;
// 删除分组
@property (nonatomic, strong) RACCommand *deleteCategoryCommand;

// 所有成员
@property (nonatomic, copy)NSArray *members;



- (CGFloat)heightForMembersWithCategoryId:(NSString *)categoryId;

@end



@interface WARCategoryMemberModel : NSObject
@property (nonatomic, copy)NSString *accountId;
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *headId;
@property (nonatomic, copy)NSString *nickName;

@end
