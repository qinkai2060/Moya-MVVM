//
//  WARNewUserDiaryTableHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#define kWARProfileBundle @"WARProfile.bundle"
 
#define kSmallIconSize CGSizeMake(15, 15)

#import "WARNewUserDiaryTableHeaderView.h" 
#import "WARNewUserDiaryTableHeaderTodayView.h"

#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"

@interface WARNewUserDiaryTableHeaderView()<WARNewUserDiaryTableHeaderTodayViewDeleagte>

/** 今日 */
@property (nonatomic, strong) WARNewUserDiaryTableHeaderTodayView *todayView;

@end

@implementation WARNewUserDiaryTableHeaderView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.todayView];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - WARNewUserDiaryTableHeaderTodayViewDeleagte

- (void)userDiaryTodayView:(WARNewUserDiaryTableHeaderTodayView *)userDiaryTodayView didItemType:(WARNewUserDiaryTodayType)itemType {
    if ([self.delegate respondsToSelector:@selector(userDiaryTableHeaderView:actionType:value:)]) {
        [self.delegate userDiaryTableHeaderView:self actionType:(WARNewUserDiaryTableHeaderActionType)itemType value:nil];
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (WARNewUserDiaryTableHeaderTodayView *)todayView {
    if (!_todayView) {
        _todayView = [[WARNewUserDiaryTableHeaderTodayView alloc]init];
        _todayView.delegate = self;
        _todayView.frame = CGRectMake(0, 0, kScreenWidth, kTodayViewHeight);
        _todayView.backgroundColor = [UIColor whiteColor];
    }
    return _todayView;
}

@end
