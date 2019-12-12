//
//  WARPhotoDetailCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoDetailCell.h"
#import "WARPhotoDetailCollectionCell.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
//#import "UIColor+WARCategory.h";
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"
#import "UIImageView+WebCache.h"
#import "WARPhotoBroswerViewController.h"
#import "WARGroupModel.h"
#import "Masonry.h"
#import "WARPhotoGroupMangerViewController.h"
@implementation WARPhotoDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.locationLb];
        [self.contentView addSubview:self.allSelectBtn];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.locationLb.mas_bottom);
            make.left.bottom.right.equalTo(self.contentView);
            
        }];
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return  self.model.arrPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WARPhotoDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photodetailsCell" forIndexPath:indexPath];

    WARPictureModel *model = self.model.arrPictures[indexPath.row];
    model.section = self.model.dateSection;
    model.rowIndex = self.model.dateRowIndex;
    cell.idenfinerStr = model.cellIdfiener;
    [cell setCSSStyle:self.type];
    
        WS(weakself);
    cell.block = ^(UIButton *btn, WARPictureModel *pmodel) {
        WARPhotoGroupMangerViewController *groupmangerVC = [weakself currentVC:weakself.contentView];
  
         if (!btn.isSelected) {
             
              NSArray *selectedModels = [NSArray arrayWithArray:groupmangerVC.selectArray];
                 for (WARPictureModel *pmModel in selectedModels) {
                     if ([pmodel.pictureId isEqualToString:pmModel.pictureId]) {
                         [groupmangerVC.selectArray removeObject:pmodel];
                         break;
                     }
                 }

         }else{

               [groupmangerVC.selectArray addObject:pmodel];
         }
      __block  NSInteger count = 0;
        [weakself.model.arrPictures enumerateObjectsUsingBlock:^(WARPictureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelect) {
                count ++;
            }else{
                  count --;
            }
        }];

        if (count == weakself.model.arrPictures.count) {
            weakself.model.rowISAllSelect = YES;
            weakself.allSelectBtn.selected =YES;
        }else{
            weakself.model.rowISAllSelect = NO;
            weakself.allSelectBtn.selected =NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:groupmangerVC.selectArray];

    };

    cell.tag = 1000+indexPath.row;
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     UIViewController *vc =    [self currentVC:self];
    WARPictureModel *model = self.model.arrPictures[indexPath.row];
    
    WARPhotoDetailCollectionCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(photoDetailCell:atMondel:atIndextPath:atCell:atPictureArr:)]) {
        WS(weakSelf);
        [self.delegate photoDetailCell:weakSelf atMondel:model atIndextPath:indexPath atCell:cell atPictureArr:weakSelf.model.arrPictures];
    }
}
- (void)allSelectClick:(UIButton*)btn{

    btn.selected = !btn.selected;

    WARPhotoGroupMangerViewController *groupmangerVC = [self currentVC:self.contentView];
    
    if(btn.selected){
        if (groupmangerVC.selectArray.count > 0) {
             NSMutableArray *tempArr = [NSMutableArray arrayWithArray:groupmangerVC.selectArray];

              for (WARPictureModel *pModel in self.model.arrPictures) {
                  if(![tempArr containsObject:pModel]){
                        [tempArr addObject:pModel];
                  }
                  
              }
            groupmangerVC.selectArray = tempArr;
            
        }else{
            [groupmangerVC.selectArray addObjectsFromArray:self.model.arrPictures];
        }
        for (WARPictureModel *model in self.model.arrPictures) {
                model.isSelect = YES;
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:groupmangerVC.selectArray];
        self.model.rowISAllSelect = YES;
    }else{
        NSInteger numberCout = groupmangerVC.selectArray.count;
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:groupmangerVC.selectArray];
        for (WARPictureModel *model in  groupmangerVC.selectArray) {
            if (model.section == self.model.dateSection) {
                
                [tempArr removeObject:model];
            }
        }
        
        groupmangerVC.selectArray = tempArr;
        for (WARPictureModel *model in self.model.arrPictures) {
            model.isSelect = NO;
            
        }
          self.model.rowISAllSelect = NO;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCount" object:groupmangerVC.selectArray];
    }
    

     [self.collectionView reloadData];
}

- (NSMutableArray *)selectArray{
     if(!_selectArray)
     {
         _selectArray = [NSMutableArray array];
     }
    return _selectArray;
}

- (NSMutableArray *)selectCellArray{
    if(!_selectCellArray)
    {
        _selectCellArray = [NSMutableArray array];
    }
    return _selectCellArray;
}

- (void)setModel:(WARDetailDateDataModel *)model {
    _model = model;
    self.locationLb.text = model.address.length==0?WARLocalizedString(@"未知"):WARLocalizedString(model.address);
    self.allSelectBtn.selected = model.rowISAllSelect;
   [self.collectionView reloadData];
}

- (void)setCSSStyle:(WARPhotoDetailViewType)type {
    self.type = type;
    if (type == WARPhotoDetailViewTypeDefualt) {
        self.allSelectBtn.hidden = NO;
    }else if (type == WARPhotoDetailViewTypeCover){
        self.allSelectBtn.hidden = YES;
    }
    else{
        self.allSelectBtn.hidden = YES;
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


- (UILabel *)locationLb {
    if (!_locationLb) {
        _locationLb = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, kScreenWidth-11-70, 21)];
        _locationLb.font = kFont(14);
        _locationLb.text = @"法国-巴黎";
        _locationLb.textColor = ThreeLevelTextColor;
    }
    return _locationLb;
}

- (UIButton *)allSelectBtn {
    if (!_allSelectBtn) {
        _allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.locationLb.frame), 0, 70, 21)];
        [_allSelectBtn setImage:[UIImage war_imageName:@""curClass:self curBundle:@""] forState:UIControlStateNormal];
        [_allSelectBtn setTitle:WARLocalizedString(@"选择") forState:UIControlStateNormal];
        [_allSelectBtn setTitle:WARLocalizedString(@"取消选择") forState:UIControlStateSelected];
        [_allSelectBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        _allSelectBtn.titleLabel.font = kFont(14);
        _allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_allSelectBtn addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
    
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((kScreenWidth-3)/4,(kScreenWidth-3)/4);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[WARPhotoDetailCollectionCell class] forCellWithReuseIdentifier:@"photodetailsCell"];
    
    }
    return _collectionView;
}
@end
