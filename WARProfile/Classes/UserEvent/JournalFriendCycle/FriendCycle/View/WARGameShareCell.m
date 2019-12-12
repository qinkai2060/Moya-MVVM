//
//  WARGameShareCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import "WARGameShareCell.h"

#import "WARMacros.h"
#import "Masonry.h"

#import "WARGameShareItemCell.h"

@interface WARGameShareCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView; 
@property (nonatomic,strong) UIView *lineView;

@end

@implementation WARGameShareCell

#pragma mark - Initial

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HEXCOLOR(0xEEEEEE);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.lineView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(14);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.equalTo (@(98));
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Event Response

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARGameShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARGameShareItemCellId forIndexPath:indexPath];
    WARGameShareItemModel *item = self.items[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Public

- (void)hideLine:(BOOL)hide {
    self.lineView.hidden = hide;
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setItems:(NSMutableArray<WARGameShareItemModel *> *)items {
    _items = items;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 12;
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((kScreenWidth-12*4-15-15)/5,98);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = HEXCOLOR(0xEEEEEE);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WARGameShareItemCell class] forCellWithReuseIdentifier:kWARGameShareItemCellId];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xDCDEE6);
    }
    return _lineView;
}
@end
