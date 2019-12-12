//
//  WARCategoryMemberTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARCategoryMemberTableViewCell.h"

#import "WARMacros.h"
#import "Masonry.h"

#import "WARCategoryMemberCell.h"
#import "WARMemberHeaderView.h"

#import "WARCategoryViewModel.h"
#import "WARContactCategoryModel.h"

#define kItemSize CGSizeMake(50, 80)
#define kInteritemItemSpace 20
#define kLineitemItemSpace 15
#define kSectionHeaderHeight 50
#define kBottomMargin 30

#define kWARCategoryMemberCellID @"kWARCategoryMemberCellID"
#define kWARMemberHeaderViewFirstID @"kWARMemberHeaderViewFirstID"
#define kWARMemberHeaderViewSecondID @"kWARMemberHeaderViewSecondID"

#define kMemberKey @"kMemberKey"
#define kSelectKey @"kSelectKey"


@interface WARCategoryMemberTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, assign) BOOL  isEdit;

@property (nonatomic, strong) NSMutableArray *addArr;
@property (nonatomic, strong) NSMutableArray *removeArr;

@property (nonatomic, strong)WARContactCategoryModel *categoryModel;


@end
@implementation WARCategoryMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collectionV];
        [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.right.mas_equalTo(-26);
            make.bottom.mas_equalTo(-kBottomMargin);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(200);
        }];
        
    }
    return self;
}


- (void)configureMembers:(NSArray *)members categoryModel:(WARContactCategoryModel *)categoryModel{

    self.categoryModel = categoryModel;
    
    NSMutableArray *topArr = [NSMutableArray array];
    NSMutableArray *bottomArr = [NSMutableArray array];

    for (WARCategoryMemberModel *item in members) {
        if ([item.categoryId isEqualToString:categoryModel.categoryId]) {
            [topArr addObject:item];
        }else{
            [bottomArr addObject:item];
        }
    }
    
    [self.dict removeAllObjects];
    [self.dict setObject:topArr forKey:kMemberKey];
    [self.dict setObject:bottomArr forKey:kSelectKey];
    

    [self reframeColletionV];
    [self.collectionV reloadData];
}


- (void)reframeColletionV{
    NSArray *topArr = self.dict[kMemberKey];
    NSArray *bottomArr = self.dict[kSelectKey];

    CGFloat topH = [self heightForMembersArr:topArr];
    CGFloat bottomH = [self heightForMembersArr:bottomArr];
    
    [self.collectionV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.bottom.mas_equalTo(-kBottomMargin);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(topH+bottomH+kSectionHeaderHeight);
    }];
}

- (CGFloat)heightForMembersArr:(NSArray *)membersArr{
    CGFloat totalHeight = kSectionHeaderHeight;
    if (membersArr.count) {
        CGFloat maxWid = kScreenWidth-26*2;
        NSInteger itemCountOfLine = floor((maxWid+kInteritemItemSpace)/(kInteritemItemSpace+kItemSize.width));
        NSInteger rowCount = ceil(membersArr.count/itemCountOfLine);
        CGFloat height = rowCount *kItemSize.height+(rowCount-1)*kLineitemItemSpace;
        
        totalHeight += height;
    }
    return totalHeight;
}


#pragma mark - collectionView delegate && datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dict.allKeys.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *arr = self.dict[kMemberKey];
        return arr.count;
    }
    NSArray *arr = self.dict[kSelectKey];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARCategoryMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARCategoryMemberCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSArray *arr = self.dict[kMemberKey];
        WARCategoryMemberModel *item = arr[indexPath.row];
        cell.type = WARCategoryMemberCellTypeOfMember;
        cell.isEdit = self.isEdit;
        [cell configureCategoryMember:item];
    }else{
        NSArray *arr = self.dict[kSelectKey];
        WARCategoryMemberModel *item = arr[indexPath.row];
        cell.type = WARCategoryMemberCellTypeOfOther;
        cell.isEdit = self.isEdit;
        [cell configureCategoryMember:item];
    }

    return cell;
}

//返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, kSectionHeaderHeight);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        WARMemberHeaderView *headerV = (WARMemberHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWARMemberHeaderViewFirstID forIndexPath:indexPath];
        headerV.backgroundColor = kColor(whiteColor);
        headerV.type = WARMemberHeaderViewTypeOfMember;
        headerV.isDefault = self.categoryModel.defaultCategory;
        
        WS(weakSelf);
        headerV.didClickEditBlock = ^(BOOL isEdit) {
            weakSelf.isEdit = isEdit;
            
            if (weakSelf.isEdit == NO) {
                weakSelf.didFinishBlock(self.addArr, self.removeArr);
                [headerV.cornerBtn titleText:WARLocalizedString(@"编辑")];
            }else{
                [headerV.cornerBtn titleText:WARLocalizedString(@"完成")];
            }
            
            [weakSelf.collectionV reloadData];
        };
        
        return headerV;
    }else{
        WARMemberHeaderView *headerV = (WARMemberHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWARMemberHeaderViewSecondID forIndexPath:indexPath];
        headerV.backgroundColor = kColor(whiteColor);
        headerV.didClickEditBlock = nil;
        headerV.type = WARMemberHeaderViewTypeOfOthers;
        return headerV;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (!self.categoryModel.defaultCategory) {
        if (indexPath.section == 0) {
            
            // 移除成员
            NSArray *memberArr = self.dict[kMemberKey];
            NSArray *selectArr = self.dict[kSelectKey];
            
            WARCategoryMemberModel *item = memberArr[indexPath.row];
            
            if (![self.removeArr containsObject:item.accountId]) {
                [self.removeArr addObject:item.accountId];
            }
            
            NSMutableArray *topMArr = [NSMutableArray array];
            for (WARCategoryMemberModel *temp in memberArr) {
                if (![temp.accountId isEqualToString:item.accountId]) {
                    [topMArr addObject:temp];
                }
            }
            
            
            
            // 移除的成员是否在新增数组中
            for (int i = 0; i < self.addArr.count; i++) {
                NSString *string = self.addArr[i];
                if ([string isEqualToString:item.accountId]) {
                    [self.addArr removeObject:string];
                }
            }
            
            NSMutableArray *bottomMArr = [NSMutableArray arrayWithArray:selectArr];
            for (WARCategoryMemberModel *temp in memberArr) {
                if ([temp.accountId isEqualToString:item.accountId]) {
                    temp.categoryId = nil;
                    [bottomMArr addObject:temp];
                    break;
                }
            }
            
            
            [self.dict setObject:topMArr forKey:kMemberKey];
            [self.dict setObject:bottomMArr forKey:kSelectKey];
            
            
        }else{
            
            // 增加成员
            NSArray *memberArr = self.dict[kMemberKey];
            NSArray *selectArr = self.dict[kSelectKey];
            
            WARCategoryMemberModel *item = selectArr[indexPath.row];
            
            if (![self.addArr containsObject:item.accountId]) {
                [self.addArr addObject:item.accountId];
            }
            
            NSMutableArray *topMArr = [NSMutableArray arrayWithArray:memberArr];
            for (WARCategoryMemberModel *temp in selectArr) {
                if ([temp.accountId isEqualToString:item.accountId]) {
                    temp.categoryId = self.categoryModel.categoryId;
                    [topMArr addObject:temp];
                    break;
                }
            }
            
            
            // 新增的成员是否在移除数组中
            for (int i = 0; i < self.removeArr.count; i++) {
                NSString *string = self.removeArr[i];
                if ([string isEqualToString:item.accountId]) {
                    [self.removeArr removeObject:string];
                }
            }
            
            NSMutableArray *bottomMArr = [NSMutableArray array];
            for (WARCategoryMemberModel *temp in selectArr) {
                if (![temp.accountId isEqualToString:item.accountId]) {
                    [bottomMArr addObject:temp];
                }
            }
            
            
            [self.dict setObject:topMArr forKey:kMemberKey];
            [self.dict setObject:bottomMArr forKey:kSelectKey];
            
        }
    
    }
    
    if (self.didEditBlock) {
        self.didEditBlock(self.dict,self.addArr, self.removeArr);
    }
    
    
    [self reframeColletionV];
    [self.collectionV reloadData];
    
}

#pragma mark - getter methods
- (UICollectionView *)collectionV{
    if (!_collectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = kItemSize;
        layout.minimumInteritemSpacing = kInteritemItemSpace;
        layout.minimumLineSpacing = kLineitemItemSpace;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) collectionViewLayout:layout];
        [_collectionV registerClass:[WARCategoryMemberCell class] forCellWithReuseIdentifier:kWARCategoryMemberCellID];
        [_collectionV registerClass:[WARMemberHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWARMemberHeaderViewFirstID];
        [_collectionV registerClass:[WARMemberHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWARMemberHeaderViewSecondID];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.backgroundColor = kColor(whiteColor);
        _collectionV.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionV;
}

- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (NSMutableArray *)addArr{
    if (!_addArr) {
        _addArr = [NSMutableArray array];
    }
    return _addArr;
}

- (NSMutableArray *)removeArr{
    if (!_removeArr) {
        _removeArr = [NSMutableArray array];
    }
    return _removeArr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
