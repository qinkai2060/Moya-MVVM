//
//  WARFaceMaskViewModel.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"
#import "WARFaceMaskModel.h"

typedef void(^successBlock)(id successData);
typedef void(^failedBlock)(id successData);

@interface WARFaceMaskViewModel : NSObject
//获取面具
@property (nonatomic, strong) RACCommand *getFacesCommand;
//修改面具
@property (nonatomic, strong) RACCommand *saveCurrentFaceCommand;
//创建面具
@property (nonatomic, strong) RACCommand *createFaceCommand;
//删除面具
@property (nonatomic, strong) RACCommand *deleteFaceCommand;

//所有的分组
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSArray *faces;


//上传图片
- (void)updateLoadImage:(NSArray *)imageArray
           successBlock:(successBlock)success
            failedBlock:(failedBlock)faild;

- (void)saveAllMasks:(NSArray *)maskArray;
- (void)saveMask:(WARFaceMaskModel *)input;

@end
