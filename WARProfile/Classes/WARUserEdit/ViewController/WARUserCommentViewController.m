//
//  WARUserTagViewController.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARUserCommentViewController.h"
#import "WARTagCollectionCell.h"
#import "WARInputCollectionViewCell.h"
#import "WARTagLableView.h"
#import "WARTagAddView.h"

#import "NSString+Size.h"
#import "WARTagItem.h"


#define TagColelctionCellId     @"TagColelctionCellId"
#define TagLabelHeaderViewId    @"TagLabelHeaderViewId"
#define TagAddTagHeaderViewId   @"TagAddTagHeaderViewId"
#define TagCollectionEmptyCellId @"TagCollectionEmptyCellId"
#define InputCollectionViewCellId   @"InputCollectionViewCellId"


#define NumberOfSection 5

@interface WARUserCommentViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WARTagAddViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedTagsArray;
@property (nonatomic, strong) NSMutableArray *defaultTagsArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) UMainControllerPersonType viewType;
@property (nonatomic, strong) NSString *accountId;

@end

@implementation WARUserCommentViewController

- (instancetype)initWithAccount:(NSString *)accountID type:(UMainControllerPersonType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.accountId = accountID;
        self.viewType = type;
    }
    
    return self;
}

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
    self.dataManager = [[WARUserEditDataManager alloc] initWithAccountID:self.accountId];
    
    [self initDefaultData];
    [self initSelectedTag];
}

- (void)initDefaultData {
    self.defaultTagsArray = [NSMutableArray arrayWithCapacity:7];
    for (int i =0 ; i < self.dataManager.allGroupsName.count; i++) {
        
        WARTagItem *item = [WARTagItem new];
        item.isSelected = NO;
        item.tagName = [self.dataManager.allGroupsName objectAtIndex:i];
        
        [self.defaultTagsArray addObject:item];
    }
}

- (void)initSelectedTag {
    self.selectedTagsArray = [[NSMutableArray alloc]  init];
    
    for (WARDBFriendTagModel *tag in self.dataManager.contactUser.friendTags) {
        BOOL isTagInDefault = NO;
        for (WARTagItem *tagItem in self.defaultTagsArray) {
            if ([tag.tagName isEqualToString:tagItem.tagName]) {
                tagItem.isSelected = YES;
                [self.selectedTagsArray addObject:tagItem];
                isTagInDefault = YES;
                break;
            }
        }
        
        if (!isTagInDefault) {
            WARTagItem *tagItem = [WARTagItem new];
            tagItem.tagName = tag.tagName;
            tagItem.isSelected = YES;
            
            [self.selectedTagsArray addObject:tagItem];
        }
    }
}


- (void)initUI {
    [super initUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.title = WARLocalizedString(@"备注信息");
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
    [self.collectionView registerClass:[WARInputCollectionViewCell class] forCellWithReuseIdentifier:InputCollectionViewCellId];
}

#pragma mark - collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if (UMainControllerPersonTypeOfFriend == self.viewType) {
        return NumberOfSection;
//    }else {
//        return NumberOfSection - 3;
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0 == section || 1 == section) {
        return 1;
    }else if (2 == section) {
        if (self.selectedTagsArray.count) {
            return self.selectedTagsArray.count;
        }else {
            return 1;
        }
        
    }else if (4 == section) {
        return self.defaultTagsArray.count ? self.defaultTagsArray.count :1;
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(self.view.frame.size.width, 20);
    if (3 == section) {
        headerSize.height = 50;
    }else if (2 == section || 4 == section){
        headerSize.height = 25;
    }
    
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(collectionView.frame.size.width - 30, 25);
    
    WARTagCollectionCell *cell = [WARTagCollectionCell new];
//    WAREmptyCollectionCell *emptyCell = [WAREmptyCollectionCell new];

    if (0 == indexPath.section) {
        itemSize.height = 40;
    }else if (1 == indexPath.section) {
        itemSize.height = 40;
    } else if (2 == indexPath.section) {
        if (self.selectedTagsArray.count) {
            WARTagItem *item = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            CGFloat textWidth = [cell.tagLabel.text sizeWithFont:cell.tagLabel.font constrainedToWidth:collectionView.frame.size.width].width + 16;//16 is the text left right insect
            itemSize.width = textWidth;
        }else {
            itemSize.height = 40;
        }
        
       
    }else if (3 == indexPath.section) {
        itemSize.width = 0;
        itemSize.height = 0;
    }else if (4 == indexPath.section) {
        if(self.defaultTagsArray.count) {
            WARTagItem *item = [self.defaultTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            
            CGFloat textWidth = [cell.tagLabel.text sizeWithFont:cell.tagLabel.font constrainedToWidth:collectionView.frame.size.width].width + 16;//16 is the text left right insect
            itemSize.width = textWidth;
        }else {
            itemSize.height = 40;
        }
    }
    
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (0 == section) {
        inset = UIEdgeInsetsMake(15, 15, 0, 15);
    }else if (1 == section){
        inset = UIEdgeInsetsMake(15, 15, 15, 15);
    }else if (2 == section){
        inset = UIEdgeInsetsMake(20, 15, 0, 15);
    }else if (3 == section) {
        inset = UIEdgeInsetsMake(0, 0, 5, 0);
    }else if (4 == section) {
        inset = UIEdgeInsetsMake(20, 15, 15, 15);
    }
    return inset;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagColelctionCellId forIndexPath:indexPath];
    WAREmptyCollectionCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCollectionEmptyCellId forIndexPath:indexPath];
    
    if (0 == indexPath.section) {
        WARInputCollectionViewCell *inputCell = [collectionView dequeueReusableCellWithReuseIdentifier:InputCollectionViewCellId forIndexPath:indexPath];
        inputCell.inputTextField.placeholder = WARLocalizedString(@"添加备注名（限12个字符）");
        inputCell.inputTextField.text = self.dataManager.contactUser.remarkName;
        
        @weakify(self);
        [inputCell.inputTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if (self.dataManager.contactUser.remarkName) {
                if ([x isEqualToString:self.dataManager.contactUser.remarkName]) {
                    if (!self.valueChanged) {//已经改变不在去改变
                        self.valueChanged = NO;
                    }
                }else {
                    self.valueChanged = YES;
                }
            }else {
                if (x && x.length > 0) {
                    self.valueChanged = YES;
                }else {
                    if (!self.valueChanged) {//已经改变不在去改变
                        self.valueChanged = NO;
                    }
                }
            }
            if (x.length > 12) {
                inputCell.inputTextField.text = [inputCell.inputTextField.text substringWithRange:NSMakeRange(0, 12)];
            }
        }];

        return inputCell;
    }else if (1 == indexPath.section) {
        emptyCell.titleLabel.text = self.dataManager.contactUser.nickname;
        emptyCell.titleLabel.textColor = COLOR_WORD_GRAY_3;
        return emptyCell;
    } else if (2 == indexPath.section) {
        if (self.selectedTagsArray.count) {
            WARTagItem *item = [self.selectedTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            cell.isSelected = item.isSelected;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"添加分组，进行更好的管理");
            return emptyCell;
        }
    }else if (4 == indexPath.section) {
        if (self.defaultTagsArray.count) {
            WARTagItem *item = [self.defaultTagsArray objectAtIndex:indexPath.row];
            cell.tagLabel.text = item.tagName;
            cell.isSelected = item.isSelected;
        }else {
            emptyCell.titleLabel.text = WARLocalizedString(@"暂无分组");
            return emptyCell;
        }
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     WARTagLableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagLabelHeaderViewId forIndexPath:indexPath];
    view.userInteractionEnabled = NO;
    view.rightLabel.text = @"";

    if (0 == indexPath.section) {
        view.titleLabel.text = WARLocalizedString(@"备注名");
        return view;
    }else if (1 == indexPath.section) {
        view.titleLabel.text = WARLocalizedString(@"昵称");
        return view;
    }else if (2 == indexPath.section) {
        view.titleLabel.text = WARLocalizedString(@"所在分组");
        return view;
    }else if (3 == indexPath.section) {
        WARTagAddView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagAddTagHeaderViewId forIndexPath:indexPath];
        view.topLine.hidden = YES;
        view.inputTextField.placeholder = WARLocalizedString(@"添加新分组（限15个字）");
        view.delegate = self;
        return view;

    }else if (4 == indexPath.section) {
        view.titleLabel.text = WARLocalizedString(@"所有分组");
        return view;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section) {
        WARTagItem *tagItem = [self.selectedTagsArray objectAtIndex:indexPath.row];
        tagItem.isSelected = !tagItem.isSelected;
        [self.selectedTagsArray removeObject:tagItem];
        [self reloadData];
        self.valueChanged = YES;
    }else if (4 == indexPath.section) {
        [self addSelectedDefaultTagsWithIndexPath:indexPath];
        [self reloadData];
         self.valueChanged = YES;
    }
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
    tagItem.isSelected = !tagItem.isSelected;
}

- (void)showTooMuchTagAlert {
    [MBProgressHUD showAutoMessage:WARLocalizedString(@"你最多可以加十个标签")];
}

#pragma mark - add button action

- (void)addButtonAction:(NSString*)tagText {
    self.valueChanged = YES;
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
                [self.defaultTagsArray addObject:tagItem];
            }
        }
        
        [self reloadData];
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)rightButtonAction {
    WARInputCollectionViewCell *cell = (WARInputCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *remarkName = cell.inputTextField.text;
    
    [MBProgressHUD showLoad];
    if (UMainControllerPersonTypeOfFriend == self.viewType) {
        NSMutableArray *selectedArray = [NSMutableArray new];
        for (WARTagItem *item in self.selectedTagsArray) {
            if (item.tagName) {
                [selectedArray addObject:item.tagName];
            }
        }
        
        [self.dataManager remarkFriendByAccount:self.accountId remarkName:remarkName tagsArray:selectedArray successBlock:^(id successData) {
            [MBProgressHUD hideHUD];
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
            NSDictionary *groupIDDict = (NSDictionary *)successData;
            [self updateFriendTags:groupIDDict];
            [self updateRemarkName:remarkName];
            [self.navigationController popViewControllerAnimated:YES];
        } failedBlock:^(id failedData) {
            [MBProgressHUD hideHUD];
        }];
    }else {
        [self.dataManager remarkStrangerByAccount:self.accountId remarkName:remarkName successBlock:^(id successData) {
            [MBProgressHUD hideHUD];
            [WARProgressHUD showAutoMessage:WARLocalizedString(@"保存成功")];
            [self updateRemarkName:remarkName];

           [self.navigationController popViewControllerAnimated:YES];
        } failedBlock:^(id failedData) {
            [MBProgressHUD hideHUD];
        }];
    }
}

- (void)updateFriendTags:(NSDictionary*)groupIDDict {
    NSMutableArray <WARDBFriendTagModel *> *friednTagsArray = [[NSMutableArray alloc] init];
    
    if (groupIDDict && [groupIDDict isKindOfClass:[NSDictionary class]]) {
        for (WARTagItem *item in self.selectedTagsArray) {
            NSString *idString = [groupIDDict objectForKey:item.tagName];
            WARDBFriendTagModel *tag = [[WARDBFriendTagModel alloc] init];
            tag.tagId = idString;
            tag.tagName = item.tagName;
            [friednTagsArray addObject:tag];            
        }
    }
    
    self.dataManager.contactUser.friendTags = friednTagsArray;
    [WARDBContactManager createOrUpdateContact:self.dataManager.contactUser];
    
    [WARDBContactManager createOrUpdateTags:friednTagsArray];
}

- (void)updateRemarkName:(NSString *)name {
    [WARDBContactManager updateContactWithAccountId:self.accountId remarkName:name];
}

@end
