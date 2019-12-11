//
//  WARCategoryViewModel.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARCategoryViewModel.h"
#import "WARNetwork.h"
#import "WARMacros.h"
#import "YYModel.h"

#import "WARFaceMaskModel.h"
#import "WARContactCategoryModel.h"
#import "WARDBUserManager.h"


#define kItemSize CGSizeMake(50, 80)
#define kInteritemItemSpace 20
#define kLineitemItemSpace 15
#define kSectionHeaderHeight 50
#define kBottomMargin 50

@implementation WARCategoryViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    @weakify(self)
    self.getContactsForCategoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/friend/all"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"page"] = @"0";
        params[@"pageSize"] = @"20";
        [WARNetwork postDataFromURI:url params:params completion:^(id responseObj, NSError *err) {
            if (!err && !kObjectIsEmpty(responseObj)) {
                
                self.members = [NSArray yy_modelArrayWithClass:[WARCategoryMemberModel class] json:responseObj];
                
            }
            
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
         return subject;
    }];
    
    
    self.updateCategoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/category/edit"];
        [WARNetwork putDataFromURI:url params:input completion:^(id responseObj, NSError *err) {
            if (!err) {
                
                NSString *faceId = input[@"faceId"];
                NSString *categoryId = input[@"categoryId"];
                if ([input.allKeys containsObject:@"addCategoryUsers"] || [input.allKeys containsObject:@"defaultCategoryUsers"]) {
                    if ([input.allKeys containsObject:@"addCategoryUsers"]){
                        WARContactCategoryModel *model = [WARDBUserManager contactCategoryWithCategoryId:categoryId];
                        NSArray *arr = input[@"addCategoryUsers"];
                        NSInteger addNum = arr.count;
                        NSInteger total = addNum + model.categoryNum;
                        [WARDBUserManager updateContactCategoryWithCategoryId:categoryId categoryNum:total];
                    }
                    
                    if ([input.allKeys containsObject:@"defaultCategoryUsers"]){
                        WARContactCategoryModel *model = [WARDBUserManager contactCategoryWithCategoryId:categoryId];
                        NSArray *arr = input[@"defaultCategoryUsers"];
                        NSInteger removeNum = arr.count;
                        NSInteger total = model.categoryNum-removeNum;
                        [WARDBUserManager updateContactCategoryWithCategoryId:categoryId categoryNum:total];
                    }
                    
                    
                }else{
                    if (faceId.length) {
                        [WARDBUserManager updateContactCategoryWithCategoryId:categoryId faceId:faceId];
                    }
                }
                
            }
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    
    
    self.updateCategoryNameCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/category/rename"];
        [WARNetwork putDataFromURI:url params:input completion:^(id responseObj, NSError *err) {
            if (!err) {
                [WARDBUserManager updateContactCategoryWithCategoryId:input[@"categoryId"] categoryName:input[@"categoryName"]];
            }
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    
    self.createCategoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (input.length) {
            [dict setObject:input forKey:@"categoryName"];
        }
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/category/create"];
        [WARNetwork postDataFromURI:url params:dict completion:^(id responseObj, NSError *err) {
            if (!err && !kObjectIsEmpty(responseObj)) {
               
                NSString *string = responseObj[@"categoryId"];
                
                if (string.length) {
                    
                    WARContactCategoryModel *model = [[WARContactCategoryModel alloc] init];
                    model.categoryName = input;
                    model.categoryId = string;
                    [WARDBUserManager updateOrCreateContactCategoryWithCategoryModel:model];
                    
                }
            }
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    
    
    self.deleteCategoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        if (input.length) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kDomainNetworkUrl,@"cont-app/category",input];
            [WARNetwork deleteDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    [WARDBUserManager deleteContactCategoryWithCategoryId:input];
                }
                [subject sendNext:err];
                [subject sendCompleted];
                
            }];
        }

        return subject;
    }];
    
}


- (CGFloat)heightForMembersWithCategoryId:(NSString *)categoryId{
    CGFloat totalHeight = kSectionHeaderHeight*4+kBottomMargin+20;
    
    NSMutableArray *topArr = [NSMutableArray array];
    NSMutableArray *bottomArr = [NSMutableArray array];
    
    if (self.members.count) {
        for (WARCategoryMemberModel *item in self.members) {
            if ([item.categoryId isEqualToString:categoryId]) {
                [topArr addObject:item];
            }else{
                [bottomArr addObject:item];
            }
        }
        
        CGFloat maxWid = kScreenWidth-26*2;
        double itemCountOfLine = floor((maxWid+kInteritemItemSpace)/(kInteritemItemSpace+kItemSize.width));
        NSInteger topRowCount = ceil(topArr.count/itemCountOfLine);
        CGFloat topHeight = topRowCount *kItemSize.height+(topRowCount-1)*kLineitemItemSpace;
        
        
        NSInteger bottomRowCount = ceil(bottomArr.count/itemCountOfLine);
        CGFloat bottomHeight = bottomRowCount *kItemSize.height+(bottomRowCount-1)*kLineitemItemSpace;
        
        totalHeight += (topHeight+bottomHeight);
    
    }
    
    return totalHeight;
}


@end


@implementation WARCategoryMemberModel


@end
