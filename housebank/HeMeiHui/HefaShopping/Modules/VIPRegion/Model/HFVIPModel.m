//
//  HFVIPModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPModel.h"
#import "HFTextCovertImage.h"
@implementation HFVIPModel
- (void)getData:(NSDictionary *)data {
    self.title = [HFUntilTool EmptyCheckobjnil:[data valueForKey:@"productName"]];
    self.imagUrl = [NSString stringWithFormat:@"%@%@!%@",[ManagerTools shareManagerTools].appInfoModel.imageServerUrl,[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"imageUrl"]],IMGWH(CGSizeMake(80, 80))];
    self.cashPrice = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"price"]] description];
    self.saleCount = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"salesCount"]] description];
    self.stock = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"stockCount"]] description];
    self.productId = [[HFUntilTool EmptyCheckobjnil:[data valueForKey:@"id"]] description];
//    self.stock = [NSString stringWithFormat:@"%d",0];
//    if (self.imagUrl.length >0) {
//        self.imagUrl = [NSString stringWithFormat:@"%@%@!YS",[ManagerTools shareManagerTools].appInfoModel.imageServerUrl,self.imagUrl];
//    }
}
@end
@implementation HFSegementModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeClassify];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeClassify;
    self.rowheight = 45;
    
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
         NSMutableArray *tempArray = [NSMutableArray array];
//         HFSegementModel *allModel = [[HFSegementModel alloc] init];
//         allModel.name = @"全部";
//         allModel.isSelected = YES;
//         allModel.channelId = @"-1";
//         allModel.pageNo = 1;
//        [tempArray addObject:allModel];
        NSInteger i = 0;
        NSArray *items = [data valueForKey:@"items"];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFSegementModel *spModel2 = [[HFSegementModel alloc] init];
                spModel2.name = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                spModel2.channelId = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"id"]] description];
                spModel2.pageNo = 1;
                if (i == 0) {
                    spModel2.isSelected = YES;
                }
                i++;
                self.horsizeW += ([HFUntilTool boundWithStr:spModel2.name blodfont:14 maxSize:CGSizeMake(kScreenSize.width-38-10, 15)].width + 25);
                [tempArray addObject:spModel2];
            }
            
        }
         self.dataArray = [tempArray copy];
    }
}

@end
@implementation HFHotKeyModel
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeHotKey];
}
- (void)getData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeHotKey;
    self.rowheight = 0;
    if ([[data valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *items = [data valueForKey:@"items"];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFHotKeyModel *spModel2 = [[HFHotKeyModel alloc] init];
                spModel2.mainTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                [tempArray addObject:spModel2];
            }
            
        }
        self.dataArray = [tempArray copy];
    }
}
- (void)getVipData:(NSDictionary *)data {
    [super getData:data];
    self.contenMode = HHFHomeBaseModelTypeHotKey;
    self.rowheight = 0;
    if ([[data valueForKey:@"result"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *items = [data valueForKey:@"result"];
        for (NSDictionary *browserDic in items) {
            if ([browserDic isKindOfClass:[NSDictionary class]]) {
                HFHotKeyModel *spModel2 = [[HFHotKeyModel alloc] init];
                spModel2.mainTitle = [[HFUntilTool EmptyCheckobjnil:[browserDic valueForKey:@"mainTitle"]] description];
                [tempArray addObject:spModel2];
            }
            
        }
        self.dataArray = [tempArray copy];
    }
}

@end
