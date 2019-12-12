//
//  WARFavriteMineView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import "WARFavriteMineView.h"
#import "WARProfileFavoriteViewController.h"
#import "WARFavriteMineCell.h"
#import "WARMacros.h"
//#import "UIColor+WARCategory.h"
#import "MJRefresh.h"
#import "WARFavriteNetWorkTool.h"
#import "WARConfigurationMacros.h"
#import "UIView+BlockGesture.h"
#import "WARActionSheet.h"
#import "WARAlertView.h"
#import "LGAlertViewTextField.h"
#define CellW    ([UIScreen mainScreen].bounds.size.width - 30-(13.5*2)*kScale_iphone6)/3
@implementation WARFavriteMineView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
//        WS(weakself);
//        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//            [weakself loadMoreData];
//        }];
    }
    return self;
}
- (void)loadMoreData {
     [self.collectionView.mj_footer beginRefreshing];
       WS(weakself);
    [WARFavriteNetWorkTool postFavoriteDatalistWithLastCreateTime:[NSString stringWithFormat:@"%ld",self.model.lastCreateTime] lastType:self.model.lastType callback:^(id response) {
        [weakself.collectionView.mj_footer endRefreshing];
        weakself.collectionView.mj_footer.hidden = YES;
        
    } failer:^(id response) {
        
    }];
}
- (void)setFavdataSource:(NSArray *)favdataSource {
    _favdataSource = favdataSource;
    [self.collectionView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    WARProfileFavoriteViewController *VC = [self currentVC:self];
    if (!VC.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
        VC.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
    
}
- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.favdataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dict = self.favdataSource[section];
    NSArray *rowArray = [dict valueForKey:@"favorite"];
    return rowArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel *headerlb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-15, 15)];
        NSDictionary *dict = self.favdataSource[indexPath.section];
        
        headerlb.text = [dict valueForKey:@"favoriteType"];
        headerlb.textColor = SubTextColor;
        headerlb.font = kFont(14);
        [headerView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [WARActionSheet actionSheetWithButtonTitles:@[@"修改分类名称",@"删除分类"] cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                if (index == 0) {
                   
                    [[LGAlertView alertViewWithTextFieldsAndTitle: WARLocalizedString(@"重命名分类名称") message:nil numberOfTextFields:1 textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {
                       
                    } buttonTitles:nil cancelButtonTitle: WARLocalizedString(@"取消") destructiveButtonTitle:WARLocalizedString(@"确定") actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                        
                        NDLog(@"");
                    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                        
                        NDLog(@"");
                    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                        LGAlertViewTextField *textField  =  [alertView.textFieldsArray firstObject];
                        if (textField.text.length == 0) {
                            
                        }else{
                            [dict setValue:textField.text forKey:@"favoriteType"];
                            
                            [self.collectionView reloadData];
                        }
                        
                        
                    }] show];
                }else{
                    [WARAlertView showWithTitle:[NSString stringWithFormat:@"%@(“%@”)吗",WARLocalizedString(@"你确定要删除"),[dict valueForKey:@"favoriteType"]] Message:nil cancelTitle:WARLocalizedString(@"取消") actionTitle:WARLocalizedString(@"确定") cancelHandler:^(LGAlertView * _Nonnull alertView) {
                        
                    } actionHandler:^(LGAlertView * _Nonnull alertView) {
                        NSMutableArray *array = [NSMutableArray arrayWithArray:self.favdataSource];
                        [array removeObjectAtIndex:indexPath.section];
                        
                        self.favdataSource = array;
                    }];
                    
                    
                }
                
            } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                
            } completionHandler:nil];
        }];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        [headerView addSubview:headerlb];
        return headerView;
    }else{
        return nil;
    }
 
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARFavriteMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mineCell" forIndexPath:indexPath];
    NSDictionary *dict = self.favdataSource[indexPath.section];
    NSArray *rowArray = [dict valueForKey:@"favorite"];
    WARFavoriteInfoModel *model = rowArray[indexPath.item];
    cell.model = model;
    return cell;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(CellW,152+5+24);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[WARFavriteMineCell class] forCellWithReuseIdentifier:@"mineCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
