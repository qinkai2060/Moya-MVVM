//
//  CloudCreatWeiShop.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudCreatWeiShop.h"

@implementation CloudCreatWeiShop

- (RACSignal *)creat_WeiShopWithDetailInfo:(NSDictionary *)info {
   
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = info;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/save"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
          if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
              NSDictionary * jsonDic = request.responseObject;
              [subject sendNext:jsonDic];
          }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)change_WeiShopWithDetailInfo:(NSDictionary *)info {
    RACSubject * subject = [RACSubject subject];
    NSDictionary * params = info;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/edit"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,utrl,sidStr] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseObject;
            [subject sendNext:jsonDic];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal * )getSelectAddress:(NSString *)address{
    
    RACSubject * subject = [RACSubject subject];
    NSString *oreillyAddress = objectOrEmptyStr(address);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil)
        {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            [subject sendNext:firstPlacemark];
          
            
        }else if ([placemarks count] == 0 && error == nil)
        {
            
            NSLog(@"Found no placemarks.");
            [subject sendNext:nil];
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
            [subject sendNext:nil];
        }
    }];
    [subject sendCompleted];
    return subject;
}

- (CGFloat)rowHeight:(NSString *)rowOfHeight
{
    CGSize contentSize = CGSizeMake(kWidth - 106, 10000);
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0]};
    CGRect rowRect = [rowOfHeight boundingRectWithSize:contentSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return ceil(rowRect.size.height);
}

- (UIImage *)addShopImage:(NSString *)shopImageString {
    NSString *str=@"";
    UIImageView * newImageView = [[UIImageView alloc]init];
    if (shopImageString.length > 0) {
        NSString *str3 = [shopImageString substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,shopImageString,@"!PD750"];
                [newImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                return newImageView.image;
            }
        }
    }
    return [UIImage imageNamed:@"SpTypes_default_image"];
}

- (RACSignal *)getShop_LogoImage {
    RACSubject * subject = [RACSubject subject];
    NSString * url =   @"/retail-api/m/shop/micro-shop/shop-picture/get";
    [HFCarRequest requsetUrl:url withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
             NSDictionary * jsonDic = request.responseObject;
            NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
            if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"pictures"]){
               NSError *jsonError;
               NSData *jsonData = [[dataDic objectForKey:@"pictures"] dataUsingEncoding:NSUTF8StringEncoding];
               NSDictionary *pictureImage = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingAllowFragments) error:&jsonError];
                if ([pictureImage.allKeys containsObject:@"detailPicture"] && [pictureImage containsObjectForKey:@"logoPicture"] ) {
                    if ([[pictureImage objectForKey:@"detailPicture"] isNotNil] && [pictureImage objectForKey:@"logoPicture"]) {
                        [subject sendNext:[RACTuple tupleWithObjects:[pictureImage objectForKey:@"detailPicture"], [pictureImage objectForKey:@"logoPicture"], nil]];
                        [subject sendCompleted];
                    }
                }
                
             }
             
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    
    return  subject;
}
@end
