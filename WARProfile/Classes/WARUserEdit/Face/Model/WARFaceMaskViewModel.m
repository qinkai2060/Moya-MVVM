//
//  WARFaceMaskViewModel.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import "WARFaceMaskViewModel.h"

#import "WARNetwork.h"
#import "WARMacros.h"
#import "YYModel.h"
#import "WARUploadDataManager.h"

#import "WARContactCategoryModel.h"
#import "WARProgressHUD.h"
#import "WARUploadManager.h"

@implementation WARFaceMaskViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    @weakify(self)
    self.getFacesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/mask/list"];
        [WARNetwork getDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err && !kObjectIsEmpty(responseObj)) {
                
//                NSArray *categories = [NSArray yy_modelArrayWithClass:[WARContactCategoryModel class] json:responseObj[@"categories"]];
//                NSArray *faces = [NSArray yy_modelArrayWithClass:[WARFaceMaskModel class] json:responseObj[@"faces"]];
                
                NSArray *faces = [NSArray yy_modelArrayWithClass:[WARFaceMaskModel class] json:responseObj];
                
//                self.categories = categories;
                self.faces = faces;
            }
            
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    

    self.saveCurrentFaceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(WARFaceMaskModel *input) {
        @strongify(self)
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        
        // 背景图
        if (input.bgId.length) {
            [mDic setObject:input.bgId forKey:@"bgId"];
        }
        
        //面具下的群组
        if (input.categoriesForCurFace.count) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (WARContactCategoryModel *item in input.categoriesForCurFace) {
                [mArr addObject:item.categoryId];
            }
            [mDic setObject:mArr forKey:@"categoryIds"];
        }
        
        // 生日
        if (input.dateStr.length) {
            [mDic setObject:input.dateStr forKey:@"birthday"];
        }else if (input.year && input.month && input.day) {
            [mDic setObject:[NSString stringWithFormat:@"%@-%@-%@",input.year, input.month, input.day] forKey:@"birthday"];
        }
        
        //面具id
        if (input.maskId.length) {
            [mDic setObject:input.maskId forKey:@"maskId"];
        }
        
        //面具icon
        if (input.faceImg.length) {
            [mDic setObject:input.faceImg forKey:@"faceImg"];
        }
        
        //性别
        if (input.gender.length) {
            [mDic setObject:input.gender forKey:@"gender"];
        }
        
        //昵称
        if (input.nickname.length) {
            [mDic setObject:input.nickname forKey:@"nickname"];
        }
        
        //签名
        if (input.signature.length) {
            [mDic setObject:input.signature forKey:@"signature"];
        }

        
//        ================= 个人信息
        //省
        if (input.province.length) {
            [mDic setObject:input.province forKey:@"province"];
        }
        if (input.provinceCode.length) {
            [mDic setObject:input.provinceCode forKey:@"provinceCode"];
        }
        
        //城市
        if (input.city.length) {
            [mDic setObject:input.city forKey:@"city"];
        }
        if (input.cityCode.length) {
            [mDic setObject:input.cityCode forKey:@"cityCode"];
        }
        
        
        //行业
        if (input.industry.length) {
            [mDic setObject:input.industry forKey:@"industry"];
        }
        
        //职业
        if (input.job.length) {
            [mDic setObject:input.job forKey:@"job"];
        }
        
        
        //情感状态
        if (input.affectiveState.length) {
            [mDic setObject:input.affectiveState forKey:@"affectiveState"];
        }
        
        
        //学校
        if (input.school.length) {
            [mDic setObject:input.school forKey:@"school"];
        }
        
        
        //公司
        if (input.company.length) {
            [mDic setObject:input.company forKey:@"company"];
        }
        
        
//        ====================== 兴趣标签
        
        // 美食
        if (input.delicacies.count) {
            [mDic setObject:input.delicacies forKey:@"delicacies"];
        }
        
        //运动
        if (input.sports.count) {
            [mDic setObject:input.sports forKey:@"sports"];
        }
        
        //旅游
        if (input.tourisms.count) {
            [mDic setObject:input.tourisms forKey:@"tourisms"];
        }
        
        //书籍
        if (input.books.count) {
            [mDic setObject:input.books forKey:@"books"];
        }
        
        //电影
        if (input.films.count) {
            [mDic setObject:input.films forKey:@"films"];
        }
        
        //音乐
        if (input.musics.count) {
            [mDic setObject:input.musics forKey:@"musics"];
        }
        
        //游戏
        if (input.games.count) {
            [mDic setObject:input.games forKey:@"games"];
        }
        
        //其他
        if (input.others.count) {
            [mDic setObject:input.others forKey:@"others"];
        }

        [mDic setObject:[NSNumber numberWithBool:input.defaults] forKey:@"defaults"];
        
        if (input.remark.length) {
            [mDic setObject:input.remark forKey:@"remark"];
        }
        
        if (input.lookImg.length) {
            [mDic setObject:input.lookImg forKey:@"lookImg"];
        }
        
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/mask/edit"];
        [WARNetwork putDataFromURI:url params:mDic completion:^(id responseObj, NSError *err) {
            if (!err && !kObjectIsEmpty(responseObj)) {
            
                
                
            }
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    
    
    
    
    self.createFaceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/mask/create"];
        [WARNetwork postDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
            if (!err && !kObjectIsEmpty(responseObj)) {
            
                WARFaceMaskModel *newFace = [WARFaceMaskModel yy_modelWithJSON:responseObj];

                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.faces];
                [mArr addObject:newFace];
                self.faces = [NSArray arrayWithArray:mArr];

            }
            [subject sendNext:err];
            [subject sendCompleted];
            
        }];
        return subject;
    }];
    
    
    
    self.deleteFaceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        @strongify(self)
        RACReplaySubject *subject = [RACReplaySubject subject];
        if (input.length) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kDomainNetworkUrl,@"cont-app/mask",input];
            [WARNetwork deleteDataFromURI:url params:nil completion:^(id responseObj, NSError *err) {
                if (!err) {
                    
                    
                    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.faces];
                    for (int i = 0; i < mArr.count; i++) {
                        WARFaceMaskModel *item = mArr[i];
                        if ([item.maskId isEqualToString:input]) {
                            [mArr removeObject:item];
                        }
                    }
                    
                    self.faces = [NSArray arrayWithArray:mArr];
                    
                }
                [subject sendNext:err];
                [subject sendCompleted];
                
            }];
        }
        return subject;
    }];
    

}



- (void)updateLoadImage:(NSArray *)imageArray
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild {
    [[WARUploadManager shared] uploadImages:imageArray uploadMoudle:WARUploadManagerTypeCONTACT progress:nil succeccBlock:^(NSArray *urlStrs) {
        if (success) {
            success(urlStrs);
        }
    } failureBlock:^{
        if(faild) {
            faild(nil);
        }
    }];
    
//    [[WARUploadDataManager sharedInstance] uploadMultiImagesWithUploadMoudle:WARUploadDataMoudleOfContact imagesArray:imageArray uploadProgressBlock:^(float progress) {
//
//    } succeccBlock:^(NSArray *urlStrs) {
//        success(urlStrs);
//    } failureBlock:^(NSString *error) {
//        faild(error);
//    }];
    
}

- (void)saveAllMasks:(NSArray *)maskArray {
    dispatch_group_t dispatchGroup = dispatch_group_create();
    __block BOOL error = NO;
    WS(weakSelf);
    [maskArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARFaceMaskModel *input = obj;
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        
        // 背景图
        if (input.bgId.length) {
            [mDic setObject:input.bgId forKey:@"bgId"];
        }
        
        //面具下的群组
        if (input.categoriesForCurFace.count) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (WARContactCategoryModel *item in input.categoriesForCurFace) {
                [mArr addObject:item.categoryId];
            }
            [mDic setObject:mArr forKey:@"categoryIds"];
        }
        
        // 生日
        if (input.dateStr.length) {
            [mDic setObject:input.dateStr forKey:@"birthday"];
        }else if (input.year && input.month && input.day) {
            [mDic setObject:[NSString stringWithFormat:@"%@-%@-%@",input.year, input.month, input.day] forKey:@"birthday"];
        }
        
        //面具id
        if (input.maskId.length) {
            [mDic setObject:input.maskId forKey:@"maskId"];
        }
        
        //面具icon
        if (input.faceImg.length) {
            [mDic setObject:input.faceImg forKey:@"faceImg"];
        }
        
        //性别
        if (input.gender.length) {
            [mDic setObject:input.gender forKey:@"gender"];
        }
        
        //昵称
        if (input.nickname.length) {
            [mDic setObject:input.nickname forKey:@"nickname"];
        }
        
        //签名
        if (input.signature.length) {
            [mDic setObject:input.signature forKey:@"signature"];
        }
        
        
        //        ================= 个人信息
        //省
        if (input.province.length) {
            [mDic setObject:input.province forKey:@"province"];
        }
        if (input.provinceCode.length) {
            [mDic setObject:input.provinceCode forKey:@"provinceCode"];
        }
        
        //城市
        if (input.city.length) {
            [mDic setObject:input.city forKey:@"city"];
        }
        if (input.cityCode.length) {
            [mDic setObject:input.cityCode forKey:@"cityCode"];
        }
        
        
        //行业
        if (input.industry.length) {
            [mDic setObject:input.industry forKey:@"industry"];
        }
        
        //职业
        if (input.job.length) {
            [mDic setObject:input.job forKey:@"job"];
        }
        
        
        //情感状态
        if (input.affectiveState.length) {
            [mDic setObject:input.affectiveState forKey:@"affectiveState"];
        }
        
        
        //学校
        if (input.school.length) {
            [mDic setObject:input.school forKey:@"school"];
        }
        
        
        //公司
        if (input.company.length) {
            [mDic setObject:input.company forKey:@"company"];
        }
        
        
        //        ====================== 兴趣标签
        
        // 美食
        if (input.delicacies.count) {
            [mDic setObject:input.delicacies forKey:@"delicacies"];
        }
        
        //运动
        if (input.sports.count) {
            [mDic setObject:input.sports forKey:@"sports"];
        }
        
        //旅游
        if (input.tourisms.count) {
            [mDic setObject:input.tourisms forKey:@"tourisms"];
        }
        
        //书籍
        if (input.books.count) {
            [mDic setObject:input.books forKey:@"books"];
        }
        
        //电影
        if (input.films.count) {
            [mDic setObject:input.films forKey:@"films"];
        }
        
        //音乐
        if (input.musics.count) {
            [mDic setObject:input.musics forKey:@"musics"];
        }
        
        //游戏
        if (input.games.count) {
            [mDic setObject:input.games forKey:@"games"];
        }
        
        //其他
        if (input.others.count) {
            [mDic setObject:input.others forKey:@"others"];
        }
        
        [mDic setObject:[NSNumber numberWithBool:input.defaults] forKey:@"defaults"];
        
        if (input.remark.length) {
            [mDic setObject:input.remark forKey:@"remark"];
        }
        
        if (input.lookImg.length) {
            [mDic setObject:input.lookImg forKey:@"lookImg"];
        }
        
        dispatch_group_enter(dispatchGroup);
        NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/mask/edit"];
        [WARNetwork putDataFromURI:url params:mDic completion:^(id responseObj, NSError *err) {
            dispatch_group_leave(dispatchGroup);
            if (err) {
                error = YES;
            }
        }];
    }];
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        if (error) {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存失败")];
        }else {
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
        }
    });
}

- (void)saveMask:(WARFaceMaskModel *)input {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    // 背景图
    if (input.bgId.length) {
        [mDic setObject:input.bgId forKey:@"bgId"];
    }
    
    //面具下的群组
    if (input.categoriesForCurFace.count) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (WARContactCategoryModel *item in input.categoriesForCurFace) {
            [mArr addObject:item.categoryId];
        }
        [mDic setObject:mArr forKey:@"categoryIds"];
    }
    
    // 生日
    if (input.dateStr.length) {
        [mDic setObject:input.dateStr forKey:@"birthday"];
    }else if (input.year && input.month && input.day) {
        [mDic setObject:[NSString stringWithFormat:@"%@-%@-%@",input.year, input.month, input.day] forKey:@"birthday"];
    }
    
    //面具id
    if (input.maskId.length) {
        [mDic setObject:input.maskId forKey:@"maskId"];
    }
    
    //面具icon
    if (input.faceImg.length) {
        [mDic setObject:input.faceImg forKey:@"faceImg"];
    }
    
    //性别
    if (input.gender.length) {
        [mDic setObject:input.gender forKey:@"gender"];
    }
    
    //昵称
    if (input.nickname.length) {
        [mDic setObject:input.nickname forKey:@"nickname"];
    }
    
    //签名
    if (input.signature.length) {
        [mDic setObject:input.signature forKey:@"signature"];
    }
    
    
    //        ================= 个人信息
    //省
    if (input.province.length) {
        [mDic setObject:input.province forKey:@"province"];
    }
    if (input.provinceCode.length) {
        [mDic setObject:input.provinceCode forKey:@"provinceCode"];
    }
    
    //城市
    if (input.city.length) {
        [mDic setObject:input.city forKey:@"city"];
    }
    if (input.cityCode.length) {
        [mDic setObject:input.cityCode forKey:@"cityCode"];
    }
    
    
    //行业
    if (input.industry.length) {
        [mDic setObject:input.industry forKey:@"industry"];
    }
    
    //职业
    if (input.job.length) {
        [mDic setObject:input.job forKey:@"job"];
    }
    
    
    //情感状态
    if (input.affectiveState.length) {
        [mDic setObject:input.affectiveState forKey:@"affectiveState"];
    }
    
    
    //学校
    if (input.school.length) {
        [mDic setObject:input.school forKey:@"school"];
    }
    
    
    //公司
    if (input.company.length) {
        [mDic setObject:input.company forKey:@"company"];
    }
    
    
    //        ====================== 兴趣标签
    
    // 美食
    if (input.delicacies.count) {
        [mDic setObject:input.delicacies forKey:@"delicacies"];
    }
    
    //运动
    if (input.sports.count) {
        [mDic setObject:input.sports forKey:@"sports"];
    }
    
    //旅游
    if (input.tourisms.count) {
        [mDic setObject:input.tourisms forKey:@"tourisms"];
    }
    
    //书籍
    if (input.books.count) {
        [mDic setObject:input.books forKey:@"books"];
    }
    
    //电影
    if (input.films.count) {
        [mDic setObject:input.films forKey:@"films"];
    }
    
    //音乐
    if (input.musics.count) {
        [mDic setObject:input.musics forKey:@"musics"];
    }
    
    //游戏
    if (input.games.count) {
        [mDic setObject:input.games forKey:@"games"];
    }
    
    //其他
    if (input.others.count) {
        [mDic setObject:input.others forKey:@"others"];
    }
    
    [mDic setObject:[NSNumber numberWithBool:input.defaults] forKey:@"defaults"];
    
    if (input.remark.length) {
        [mDic setObject:input.remark forKey:@"remark"];
    }
    
    if (input.lookImg.length) {
        [mDic setObject:input.lookImg forKey:@"lookImg"];
    }

    NSString *url = [NSString stringWithFormat:@"%@/%@",kDomainNetworkUrl,@"cont-app/mask/edit"];
    [WARNetwork putDataFromURI:url params:mDic completion:^(id responseObj, NSError *err) {
        if (!err && !kObjectIsEmpty(responseObj)) {
        }
    }];
}

#pragma mark - getter methods

@end
