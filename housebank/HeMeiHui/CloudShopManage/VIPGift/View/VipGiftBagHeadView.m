//
//  VipGiftBagHeadView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftBagHeadView.h"
@interface VipGiftBagHeadView ()
@property (nonatomic, strong) NSArray * imagesArray;
@property (nonatomic, strong) NSMutableArray * allDataSource;
@end
@implementation VipGiftBagHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setUpUI {
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"topBanner" ofType:@"jpg"];
//    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
//    if ([UIDevice currentDevice].systemVersion.doubleValue>=8.0) {
//        image = [UIImage imageWithContentsOfFile:filePath];
//    }else{
//        image = [UIImage imageWithContentsOfFile:[filePath stringByAppendingString:@"@2x.png"]];
//    }
   
}

- (NSURL *)getImageURLWithImageString:(NSString *)string {
    NSString *url = [NSString stringWithFormat:@"https://m.hfhomes.cn/images/vip/%@.jpg",string];
    return [NSURL URLWithString:url];
}

- (void)setHeadDic:(NSDictionary *)headDic withIndexPath:(NSInteger)path{

#pragma mark -- 第一区头才会添加展示图
    [self.allDataSource removeAllObjects];
    for (UIView * item in self.subviews) {
        [item removeFromSuperview];
    }
    UIImageView *bgView = [[UIImageView alloc]init];
    if (path == 0) {
        [bgView sd_setImageWithURL:[self getImageURLWithImageString:@"topBanner"]];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        bgView.frame = CGRectMake(0, 0, kWidth, 200);
    }
//    if (path == 0) {
//        if (headArray.count > 0) {
//            self.imagesArray = headArray.copy;
//            for (NSInteger i = 0; i < self.imagesArray.count; i++) {
//                NSDictionary * dic = self.imagesArray[i];
//                if ([dic.allKeys containsObject:@"img"] && [dic objectForKey:@"img"]) {
//                    UIImageView * imageView = [[UIImageView alloc]init];
//                    NSString * url = [dic objectForKey:@"img"];
//                    if (self.allDataSource.count > 0) {
//
//                        // 判断内存中有没有存入的图片数据，有的话，过滤，没有那么加内存中，加载
//                        BOOL have = [self compareWithUniqueFlag:url];
//                        if (!have) {
//                            [self.allDataSource addObject:url];
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:objectOrEmptyStr(url)] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
//                            [self addSubview:imageView];
//                            imageView.frame = CGRectMake(0, (self.allDataSource.count - 1)*100, kWidth, 100);
//                        }
//                    }else{
//                        [self.allDataSource addObject:url];
//                        [imageView sd_setImageWithURL:[NSURL URLWithString:objectOrEmptyStr(url)] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
//                        [self addSubview:imageView];
//                        imageView.frame = CGRectMake(0, i*100, kWidth, 100);
//                    }
//                }
//            }
//        }
//    }
    
#pragma mark -- 头部选择区域
    [self addSubview:self.headSelectView];
    [self.headSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(bgView.mas_bottom);
        make.height.equalTo(@83);
    }];
    @weakify(self);
    [self.headSelectView setUpHeadDataSource:headDic index:path heightBlock:^(CGFloat height) {
        @strongify(self);
        [self.headSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
            make.left.right.equalTo(self);
            make.top.equalTo(bgView.mas_bottom);
        }];
    }];
}

- (BOOL)compareWithUniqueFlag:(NSString *)flag {
    for (NSInteger i = 0; i < self.allDataSource.count; i++) {
        NSString * loadUrl = self.allDataSource[i];
        if ([loadUrl isEqualToString:flag]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- lazy load
- (NSArray *)imagesArray {
    if(!_imagesArray) {
        _imagesArray = [NSArray array];
    }
    return _imagesArray;
}

- (NSMutableArray *)allDataSource {
    if (!_allDataSource) {
        _allDataSource = [NSMutableArray array];
    }
    return _allDataSource;
}

- (VIPGiftSelectHeadView *)headSelectView {
    if (!_headSelectView) {
        _headSelectView = [[VIPGiftSelectHeadView alloc]init];
    }
    return _headSelectView;
}
@end
