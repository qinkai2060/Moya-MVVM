//
//  WARUserTagViewController.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARUserTagViewController.h"
#import "WARTagCollectionCell.h"
#import "WARTagLableView.h"
#import "WARTagAddView.h"

#import "NSString+Size.h"
#import "WARTagItem.h"


#define TagColelctionCellId     @"TagColelctionCellId"
#define TagLabelHeaderViewId    @"TagLabelHeaderViewId"
#define TagAddTagHeaderViewId   @"TagAddTagHeaderViewId"
#define TagCollectionEmptyCellId @"TagCollectionEmptyCellId"


#define NumberOfSection 3

@interface WARUserTagViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WARTagAddViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedTagsArray;
@property (nonatomic, strong) NSMutableArray *defaultTagsArray;
@property (nonatomic, strong) NSMutableArray *customTagsArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WARUserTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataManager = [WARUserEditDataManager new];
    [self initDefaultData];
    
    self.selectedTagsArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.customTagsArray = [[NSMutableArray alloc] initWithCapacity:10];

    for (NSString *tagString in self.dataManager.user.tags) {
        BOOL isTagInDefault = NO;
        for (WARTagItem *tagItem in self.defaultTagsArray) {
            if ([tagString isEqualToString:tagItem.tagName]) {
                tagItem.isSelected = YES;
                [self.selectedTagsArray addObject:tagItem];
                isTagInDefault = YES;
                break;
            }
        }
        
        if (!isTagInDefault) {
            WARTagItem *tagItem = [WARTagItem new];
            tagItem.tagName = tagString;
            tagItem.isSelected = YES;
            
            [self.selectedTagsArray addObject:tagItem];
            [self.customTagsArray addObject:tagItem];
        }
    }
}

- (void)initDefaultData {
    self.defaultTagsArray = [NSMutableArray arrayWithCapacity:7];
    for (int i =0 ; i < 7; i++) {
        WARTagItem *item = [WARTagItem new];
        item.isSelected = NO;
        
        switch (i) {
            case 0: {
                item.tagName = @"电影";
            }
                break;
            case 1: {
                item.tagName = @"书籍";
            }
                break;
            case 2: {
                item.tagName = @"美食";
            }
                break;
            case 3: {
                item.tagName = @"运动";
            }
                break;
            case 4: {
                item.tagName = @"音乐";
            }
                break;
            case 5: {
                item.tagName = @"游戏";
            }
                break;
            case 6: {
                item.tagName = @"旅游";
            }
                break;
            default:
                break;
        }
        
        [self.defaultTagsArray addObject:item];
    }
}

- (void)initUI {
    [super initUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.title = WARLocalizedString(@"标签");
    self.rightButtonText = WARLocalizedString(@"保存");
    self.navigationBarClear = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCollectionView];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
    }];
    
    
    [self.collectionView registerClass:[WARTagCollectionCell class] forCellWithReuseIdentifier:TagColelctionCellId];
    [self.collectionView registerClass:[WARTagAddView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagAddTagHeaderViewId];
    [self.collectionView registerClass:[WARTagLableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagLabelHeaderViewId];
    [self.collectionView registerClass:[WAREmptyCollectionCell class] forCellWithReuseIdentifier:TagCollectionEmptyCellId];
}

#pragma mark - collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return NumberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0 == section) {
        if (self.selectedTagsArray.count) {
            return self.selectedTagsArray.count;
        }else {
            return 1;
        }
    }else if (1 == section) {
        return self.defaultTagsArray.count;
    }else if (2 == section) {
        if (self.customTagsArray.count) {
            return self.customTagsArray.count;
        }else {
            return 1;
        }
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(self.view.frame.size.width, 0);
    if (1 == section) {
        headerSize.height = 100;
    }else {
        headerSize.height = 30;
    }
    
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(120, 25);
    
    WARTagCollectionCell *cell = [WARTagCollectionCell new];
    WAREmptyCollectionCell *emptyCell = [WAREmptyCollectionCell new];
    
    if (0 == indexPath.section) {
        if (self.selectedTagsArray.count) {
            WARTagItem *item = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"添加个性标签");
        }
    }else if (1 == indexPath.section) {
        WARTagItem *item = [self.defaultTagsArray objectAtIndex:indexPath.row];
        cell.tagLabel.text = item.tagName;
    }else if (2 == indexPath.section) {
        if (self.customTagsArray.count) {
            WARTagItem *item = [self.customTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"暂无自定义标签");
        }
    }

    CGFloat textWidth = 0;
    if (cell.tagLabel.text.length) {
        textWidth = [cell.tagLabel.text sizeWithFont:cell.tagLabel.font constrainedToWidth:collectionView.frame.size.width].width + 16;//16 is the text left right insect
        itemSize.width = textWidth;
    }else {
        textWidth = [emptyCell.titleLabel.text sizeWithFont:emptyCell.titleLabel.font constrainedToWidth:collectionView.frame.size.width].width + 16;//16 is the text left right insect
        itemSize.width = textWidth;
    }
    
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagColelctionCellId forIndexPath:indexPath];
    WAREmptyCollectionCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCollectionEmptyCellId forIndexPath:indexPath];
    
    if (0 == indexPath.section) {
        if (self.selectedTagsArray.count) {
            WARTagItem *item = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            cell.isSelected = item.isSelected;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"添加个性标签");
            return emptyCell;
        }
    }else if (1 == indexPath.section) {
        WARTagItem *item = [self.defaultTagsArray objectAtIndex:indexPath.row];
        cell.tagLabel.text = item.tagName;
        cell.isSelected = item.isSelected;
    }else if (2 == indexPath.section) {
        if (self.customTagsArray.count) {
            WARTagItem *item = [self.customTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            cell.isSelected = item.isSelected;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"暂无自定义标签");
            return emptyCell;
        }
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        WARTagAddView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagAddTagHeaderViewId forIndexPath:indexPath];
        view.delegate = self;
        view.titleLabel.text = WARLocalizedString(@"选择你的标签");
        return view;
    }else {
        WARTagLableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagLabelHeaderViewId forIndexPath:indexPath];
        
        if (0 == indexPath.row && 0 == indexPath.section) {
            view.titleLabel.text = WARLocalizedString(@"已选择标签");
            view.rightLabel.text = [NSString stringWithFormat:@"%ld/10",self.selectedTagsArray.count];
        }else {
            view.titleLabel.text = WARLocalizedString(@"自定义标签");
            view.rightLabel.text = @"";
        }
        
        return view;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        WARTagItem *tagItem = [self.selectedTagsArray objectAtIndex:indexPath.row];
        tagItem.isSelected = !tagItem.isSelected;
        [self.selectedTagsArray removeObject:tagItem];
        [self reloadData];
    }else if (1 == indexPath.section) {
        [self addSelectedDefaultTagsWithIndexPath:indexPath];
        [self reloadData];
    }else if (2 == indexPath.section) {
        WARTagItem *tagItem = [self.customTagsArray objectAtIndex:indexPath.row];
        tagItem.isSelected = !tagItem.isSelected;
        
        BOOL isExist = NO;
        for (WARTagItem *item in self.selectedTagsArray) {
            if ([item.tagName isEqualToString:tagItem.tagName]) {
                [self.selectedTagsArray removeObject:item];
                isExist = YES;
                break;
            }
        }
        
        if (!isExist) {
            [self.selectedTagsArray addObject:tagItem];
        }
        
        [self reloadData];
    }
    self.valueChanged = YES;
}

- (void)addSelectedDefaultTagsWithIndexPath:(NSIndexPath *)indexPath {
    WARTagItem *tagItem = [self.defaultTagsArray objectAtIndex:indexPath.row];
    if (tagItem.isSelected) {
        for (WARTagItem *temItem in self.selectedTagsArray) {
            if ([temItem.tagName isEqualToString:tagItem.tagName]) {
                [self.selectedTagsArray removeObject:temItem];
                break;
            }
        }
    }else {
        if (self.selectedTagsArray.count > 9) {
            [self showTooMuchTagAlert];
            return;
        }else {
            BOOL isExit = NO;
            for (WARTagItem *temItem in self.selectedTagsArray) {
                if ([temItem.tagName isEqualToString:tagItem.tagName]) {
                    [self.selectedTagsArray removeObject:temItem];
                    isExit = YES;
                    break;
                }
            }
            
            if (!isExit) {
                [self.selectedTagsArray addObject:tagItem];
            }
        }
    }
    tagItem.isSelected = !tagItem.isSelected;
}

- (void)showTooMuchTagAlert {
    [MBProgressHUD showAutoMessage:WARLocalizedString(@"你最多可以加十个标签")];
}

#pragma mark - add button action

- (void)addButtonAction:(NSString*)tagText {
    self.valueChanged = YES;
    
    if (self.selectedTagsArray.count > 9) {
        [self showTooMuchTagAlert];
        return;
    }
    if (tagText && tagText.length) {
        BOOL isExistInDefaultTags = NO;
        
        for (WARTagItem *tempItem in self.defaultTagsArray) {
            if ([tagText isEqualToString:tempItem.tagName]) {
                isExistInDefaultTags = YES;
                tempItem.isSelected = YES;
                break;
            }
        }
        
        if (isExistInDefaultTags) {
            BOOL isExistInSelected = NO;
            for (WARTagItem *tempItem  in self.selectedTagsArray) {
                if ([tagText isEqualToString:tempItem.tagName]) {
                    isExistInSelected = YES;
                    break;
                }
            }
            
            if (!isExistInSelected) {
                WARTagItem *tagItem = [WARTagItem new];
                tagItem.tagName = tagText;
                tagItem.isSelected = YES;
                [self.selectedTagsArray addObject:tagItem];
            }
        }else {
            BOOL isExistInSelected = NO;
            for (WARTagItem *tempItem  in self.selectedTagsArray) {
                if ([tagText isEqualToString:tempItem.tagName]) {
                    isExistInSelected = YES;
                    break;
                }
            }
            
            WARTagItem *tagItem = nil;
            if (!isExistInSelected) {
                tagItem = [WARTagItem new];
                tagItem.tagName = tagText;
                tagItem.isSelected = YES;
                [self.selectedTagsArray addObject:tagItem];
            }
            
            
            BOOL isExistInCustom = NO;
            for (WARTagItem *tempItem  in self.customTagsArray) {
                if ([tagText isEqualToString:tempItem.tagName]) {
                    tempItem.isSelected = YES;
                    isExistInCustom = YES;
                    break;
                }
            }
            
            if (!isExistInCustom && tagItem) {
                [self.customTagsArray addObject:tagItem];
            }

        }
        
        [self reloadData];
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)rightButtonAction {
    [MBProgressHUD showLoad];
    [self.dataManager changeTagsWithTagItemArray:self.selectedTagsArray successBlock:^(id successData) {
        [MBProgressHUD hideHUD];
        [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
        [self.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(id failedData) {
        [MBProgressHUD hideHUD];
        
    }];
}
@end
