//
//  WARThumbModel.m
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import "WARThumbModel.h"
#import "MJExtension.h"
#import "ReactiveObjC.h"
#import "WARMacros.h"
#import "WARDBContactHelper.h"
#import "WARDBUserManager.h"
#import "UIImage+WARBundleImage.h"

#define kLimitLikeCount 50

@implementation WARThumbModel

- (NSArray<WARMomentUser *> *)thumbUserBos {
    if (!_thumbUserBos) {
        _thumbUserBos = [NSArray array];
    }
    return _thumbUserBos;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //点赞信息
        [[RACSignal combineLatest:@[RACObserve(self, thumbUserBos)] reduce:^id (NSArray <WARMomentUser *> *thumbUserBos){
            
            if (thumbUserBos.count > 0) {
                [self buildThumbUsersAttributedContent:thumbUserBos];
            }
            
            //是否显示点赞的展开收起按钮
            _showLikeExtend = thumbUserBos.count > kLimitLikeCount;
            
            return @(1);
        }] subscribeNext:^(NSNumber* number) {
            
        }];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"thumbUserBos" : @"WARMomentUser"};//前边，是属性数组的名字，后边就是类名
}

- (void)buildThumbUsersAttributedContent:(NSArray<WARMomentUser *> *)thumbUserBos  {
    NSArray<WARMomentUser *> *thumbUsersCopy = [thumbUserBos copy];
    
    UIImage *image = [UIImage war_imageName:@"great_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = image;
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    NSMutableAttributedString *limitAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [limitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    NSMutableAttributedString *noIconAttributedText = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *noIconLimitAttributedText = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < thumbUsersCopy.count; i++) {
        WARMomentUser *model = thumbUsersCopy[i];
        if (i > 0) {
            
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            [noIconAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            if (i < kLimitLikeCount) {
                [limitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
                [noIconLimitAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            }
        }
        
        NSAttributedString *attributedContent = [self generateAttributedStringWithLikeItemName:model.nickname accoundId:model.accountId];
        
        if (i < kLimitLikeCount) {
            [limitAttributedText appendAttributedString:attributedContent];
            [noIconLimitAttributedText appendAttributedString:attributedContent];
        }
        [attributedText appendAttributedString:attributedContent];
        [noIconAttributedText appendAttributedString:attributedContent];
    }
    _thumbUsersAttributedContent = [attributedText mutableCopy];
    _limitThumbUsersAttributedContent = [limitAttributedText mutableCopy];
    
    _noIconThumbUsersAttributedContent = [noIconAttributedText mutableCopy];
    _noIconLimitThumbUsersAttributedContent = [noIconLimitAttributedText mutableCopy];
}

/**
 入参不要为nil,否则会想哭
 
 @param name name description
 @param accountId accountId description
 @return return value description
 */
- (NSAttributedString *)generateAttributedStringWithLikeItemName:(NSString *)name accoundId:(NSString *)accountId{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",name]];
    UIColor *highLightColor = [UIColor clearColor];
    
    
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : accountId} range:[name rangeOfString:[NSString stringWithFormat:@"%@",name]]];
    
    return attString;
}

@end
