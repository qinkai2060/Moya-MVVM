//
//  MSSCalendarViewController.m
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import "MSSCalendarViewController.h"
#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarHeaderModel.h"
#import "MSSCalendarManager.h"
#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarPopView.h"
#import "GSCollectionViewFlowLayout.h"
#import "UIView+addGradientLayer.h"

@interface MSSCalendarViewController ()
@property (nonatomic,strong)UIView *weekView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)MSSCalendarPopView *popView;
@property (nonatomic,strong)NSIndexPath*endIndexpath;
@end

@implementation MSSCalendarViewController
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _afterTodayCanTouch = YES;
        _beforeTodayCanTouch = YES;
        _dataArray = [[NSMutableArray alloc]init];
        _showChineseCalendar = NO;
        _showChineseHoliday = NO;
        _showHolidayDifferentColor = NO;
        _showAlertView = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataSource];
    [self addWeakView];
    [self createUI];
    [self performSelector:@selector(showAleart)withObject:nil afterDelay:0.5];
  
}
-(void)showAleart
{
    [self showPopViewWithIndexPath:self.endIndexpath type:2];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}

- (void)initDataSource
{

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:self->_showChineseHoliday showChineseCalendar:self->_showChineseCalendar startDate:self->_startDate];
            NSArray *tempDataArray = [manager getCalendarDataSoruceWithLimitMonth:self->_limitMonth type:self->_type];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_dataArray addObjectsFromArray:tempDataArray];
                [self showCollectionViewWithStartIndexPath:manager.startIndexPath];
            });
        });
}

- (void)addWeakView
{
    self.weekView = [[UIView alloc]initWithFrame:CGRectMake(0,AlphaHeaderViewHeight, ScreenW, ScreenH-AlphaHeaderViewHeight)];
    self.weekView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self.view addSubview:self.weekView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.backgroundColor = HEXCOLOR(0xFFFFFF);
    titleLable.text = @"选择日期";
    titleLable.textColor=HEXCOLOR(0x333333);
    [self.weekView addSubview:titleLable];
    UIButton *clossBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    clossBtn.frame=CGRectMake(ScreenW-30, 15, 15, 15);
    [clossBtn setImage:[UIImage imageNamed:@"order_detail_cancel"] forState:UIControlStateNormal];
    [clossBtn addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addSubview:clossBtn];
    
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    int i = 0;
    NSInteger width = MSS_Iphone6Scale(54);
    for(i = 0; i < 7;i++)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 44, width, 30)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.text = weekArray[i];
        weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if(i == 0 || i == 6)
        {
            weekLabel.textColor = HEXCOLOR(0xFF6600);
        }
        else
        {
            weekLabel.textColor = HEXCOLOR(0x333333);
        }
        [self.weekView addSubview:weekLabel];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,ScreenH-AlphaHeaderViewHeight-KBottomSafeHeight-50,ScreenW, 50);
    [btn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFA8C1D).CGColor,(id)HEXCOLOR(0xFCAD3E).CGColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addSubview:btn];
}
- (void)createUI
{
    
//    CGFloat width = ScreenW/7;
    CGFloat width =ScreenW/7;
    CGFloat height = MSS_Iphone6Scale(50);
//    GSCollectionViewFlowLayout
//    GSCollectionViewFlowLayout *flowLayout = [[GSCollectionViewFlowLayout alloc]init];
//    flowLayout.itemSize = CGSizeMake(width, height);
//    flowLayout.headerReferenceSize = CGSizeMake(ScreenW, MSS_HeaderViewHeight);
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 0;
    
    UICollectionViewFlowLayout*flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.headerReferenceSize = CGSizeMake(ScreenW, MSS_HeaderViewHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, MSS_WeekViewHeight, ScreenW, ScreenH-AlphaHeaderViewHeight- MSS_WeekViewHeight-KBottomSafeHeight-50) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.weekView addSubview:_collectionView];
    
    [_collectionView registerClass:[MSSCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell"];
    [_collectionView registerClass:[MSSCalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSSCalendarCollectionReusableView"];
}
- (void)showCollectionViewWithStartIndexPath:(NSIndexPath *)startIndexPath
{
    
    [_collectionView reloadData];
    // 滚动到上次选中的位置
    if(startIndexPath)
    {
        [_collectionView scrollToItemAtIndexPath:startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
    }
    else
    {
        if(_type == MSSCalendarViewControllerLastType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArray.count - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }
        else if(_type == MSSCalendarViewControllerMiddleType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(_dataArray.count - 1) / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
            }
        }
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MSSCalendarHeaderModel *headerItem = _dataArray[section];
    return headerItem.calendarItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell" forIndexPath:indexPath];
    if(cell)
    {
        cell.contentView.backgroundColor = [UIColor clearColor];

        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendarItem = headerItem.calendarItemArray[indexPath.row];
        cell.dateLabel.text = @"";
        cell.dateLabel.textColor = HEXCOLOR(0x666666);
        cell.tagLabel.text=@"";
        cell.tagLabel.textColor = HEXCOLOR(0x666666);
        cell.subLabel.text = @"";
        cell.subLabel.textColor = HEXCOLOR(0xFF6600);
        cell.isSelected = NO;
        cell.userInteractionEnabled = NO;
         [self cuttingLayerRoundedCorners:cell type:0];
        if(calendarItem.day > 0)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarItem.day];
            cell.userInteractionEnabled = YES;
        }
        if(_showChineseCalendar)
        {
            cell.subLabel.text = calendarItem.chineseCalendar;
        }
        // 开始日期
        if(calendarItem.dateInterval == _startDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = HEXCOLOR(0xFFFFFF);
            cell.subLabel.text = @"开始";
            cell.contentView.backgroundColor = HEXCOLOR(0xFA8C1D);
            cell.subLabel.textColor = HEXCOLOR(0xFFFFFF);
            if (self.calendarType == MSSCalendarTrainType || self.calendarType == MSSCalendarPlaneType) {
                cell.subLabel.text = @"出发";
            }else if(self.calendarType == MSSCalendarHotelType){
                cell.subLabel.text = @"入住";
            }else if (self.calendarType == MSSCalendarAplaceType){
                cell.subLabel.text = @"开始";
            }
             [self cuttingLayerRoundedCorners:cell type:1];
//            [self showPopViewWithIndexPath:indexPath type:1];
        }
        // 结束日期
        else if (calendarItem.dateInterval == _endDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = HEXCOLOR(0xFFFFFF);
            cell.subLabel.textColor = HEXCOLOR(0xFFFFFF);
            cell.subLabel.text = @"结束";
            cell.contentView.backgroundColor = HEXCOLOR(0xFA8C1D);
            cell.subLabel.text = @"离店";
            [self cuttingLayerRoundedCorners:cell type:2];
            self.endIndexpath=indexPath;
//            [self showPopViewWithIndexPath:indexPath type:2];
        }
        // 开始和结束之间的日期
        else if(calendarItem.dateInterval > _startDate && calendarItem.dateInterval < _endDate)
        {
            if(calendarItem.week == 0 || calendarItem.week == 6)
            {//节日颜色

                cell.dateLabel.textColor = HEXCOLOR(0xFF6600);
                cell.subLabel.textColor = HEXCOLOR(0x666666);
            }else
            {
               cell.dateLabel.textColor = HEXCOLOR(0x666666);
                cell.subLabel.textColor = HEXCOLOR(0x666666);
            }
            cell.isSelected = YES;
            cell.contentView.backgroundColor = HEXCOLOR(0xF5F5F5);

        }
        else
        {
            if(calendarItem.week == 0 || calendarItem.week == 6)
            {//节日颜色
                
                cell.dateLabel.textColor = HEXCOLOR(0xFF6600);
                cell.subLabel.textColor = HEXCOLOR(0x666666);
            }
            if(calendarItem.holiday.length > 0)
            {
             
               
                if(_showHolidayDifferentColor)
                {
                    if ([calendarItem.holiday isEqualToString:@"今天"]||[calendarItem.holiday isEqualToString:@"明天"]||[calendarItem.holiday isEqualToString:@"后天"]) {
                        cell.dateLabel.text=calendarItem.holiday;
                        cell.dateLabel.textColor = HEXCOLOR(0x666666);
                        cell.subLabel.textColor = HEXCOLOR(0x666666);
                        cell.tagLabel.textColor= HEXCOLOR(0x666666);
                    }else
                    {
                        cell.tagLabel.text=calendarItem.holiday;
                        cell.tagLabel.textColor= HEXCOLOR(0xFF6600);
                        cell.dateLabel.textColor = HEXCOLOR(0xFF6600);
                        cell.subLabel.textColor = HEXCOLOR(0x666666);
                    }
                    
                }
            }
        }

        if(!_afterTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarNextType)
            {// 不可点击文字颜色
                cell.dateLabel.textColor = HEXCOLOR(0xCCCCCC);
                cell.subLabel.textColor = HEXCOLOR(0xCCCCCC);
                cell.tagLabel.textColor=  HEXCOLOR(0xCCCCCC);
                cell.userInteractionEnabled = NO;
            }
        }
        if(!_beforeTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarLastType)
            {// 不可点击文字颜色
                cell.dateLabel.textColor = HEXCOLOR(0xCCCCCC);
                cell.subLabel.textColor = HEXCOLOR(0xCCCCCC);
                cell.tagLabel.textColor=  HEXCOLOR(0xCCCCCC);
                cell.userInteractionEnabled = NO;
            }
        }
    }
    return cell;

}

// 添加header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MSSCalendarCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MSSCalendarCollectionReusableView" forIndexPath:indexPath];
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        headerView.headerLabel.text = headerItem.headerText;
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.calendarType == MSSCalendarHotelType) {
        
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendaItem = headerItem.calendarItemArray[indexPath.row];
        // 当开始日期为空时
        if(_startDate == 0)
        {
            _startDate = calendaItem.dateInterval;
            [self showPopViewWithIndexPath:indexPath type:1];
//             [self cuttingLayerRoundedCorners:cell type:1];
        }
        // 当开始日期和结束日期同时存在时(点击为重新选时间段)
        else if(_startDate > 0 && _endDate > 0)
        {
            _startDate = calendaItem.dateInterval;
            _endDate = 0;
            [self showPopViewWithIndexPath:indexPath type:1];
//            [self cuttingLayerRoundedCorners:cell type:1];
        }
        else
        {
            // 判断第二个选择日期是否比现在开始日期大
            if(_startDate < calendaItem.dateInterval)
            {
                _endDate = calendaItem.dateInterval;
               [self showPopViewWithIndexPath:indexPath type:2];
//               [self cuttingLayerRoundedCorners:cell type:2];
            }
            else
            {
                _startDate = calendaItem.dateInterval;
                [self showPopViewWithIndexPath:indexPath type:1];
//                [self cuttingLayerRoundedCorners:cell type:1];
            }
        }
        [_collectionView reloadData];
        
    }else{
        
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendaItem = headerItem.calendarItemArray[indexPath.row];
        // 当开始日期为空时
        _startDate = calendaItem.dateInterval;
        _endDate = 0;
        
        if([_delegate respondsToSelector:@selector(calendarViewConFirmClickWithStartDate:)])
        {
            [_delegate calendarViewConFirmClickWithStartDate:_startDate];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        
        [_collectionView reloadData];
        
    }
    
}
//滚动隐藏popView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if(_popView)
//    {
//       _popView.y=_popView.y+scrollView.contentOffset.y;
//    }
    
//}
- (void)showPopViewWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type;
{
 
    if(_showAlertView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
        MSSCalendarPopViewArrowPosition arrowPostion = MSSCalendarPopViewArrowPositionMiddle;
        NSInteger position = indexPath.row % 7;
        if(position == 0)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionLeft;
        }
        else if(position == 6)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionRight;
        }
        
        MSSCalendarCollectionViewCell *cell = (MSSCalendarCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        _popView = [[MSSCalendarPopView alloc]initWithSideView:cell.dateLabel arrowPosition:arrowPostion];
        switch (type) {
            case 1://住店
            {
                _popView.topLabelText = [NSString stringWithFormat:@"请选择%@日期",@"离店"];
            }
                break;
            case 2://离店
            {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
                //比较的结果是NSDateComponents类对象
                NSDateComponents *delta = [calendar components:unit fromDate: [NSDate dateWithTimeIntervalSince1970:_startDate] toDate: [NSDate dateWithTimeIntervalSince1970:_endDate] options:0];
            NSDate * startDay=[MyUtil timestampToDate:_startDate];
            NSDate * endDay=[MyUtil timestampToDate:_endDate];
            NSString* days= [MyUtil getDays:startDay endDay:endDay];
               _popView.topLabelText = [NSString stringWithFormat:@"共%ld晚",delta.day];
            }
                break;
                
            default:
                break;
        }
      
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMdd"];
        NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
        _popView.bottomLabelText = startDateString;
        [_popView showWithAnimation];
    }
}

-(void)calendarClick:(UIButton*)sender
{
    if (_startDate&&_endDate) {
        if([_delegate respondsToSelector:@selector(calendarViewConfirmClickWithStartDate:endDate:)])
        {
            [_delegate calendarViewConfirmClickWithStartDate:_startDate endDate:_endDate];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择住店离店日期"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 确定按钮的点击事件
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
#pragma mark - life cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}

- (void)dissmiss {
    [UIView animateWithDuration:0.5

                     animations:^{
                         self.weekView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}
//选择日期切角
-(void)cuttingLayerRoundedCorners:(MSSCalendarCollectionViewCell*)cell type:(NSInteger)type
{
    UIBezierPath *maskPath;
    switch (type) {
        case 0:
        {//其他
            maskPath= [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                            byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                  cornerRadii:CGSizeMake(0,0)];
            CAShapeLayer*maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            
        }
            break;
        case 1:
            {//开始
            maskPath= [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                      cornerRadii:CGSizeMake(5,5)];
                CAShapeLayer*maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cell.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                
            }
            break;
        case 2:
        {//结束
            maskPath= [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                            byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                  cornerRadii:CGSizeMake(5,5)];
            CAShapeLayer*maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
            break;
            
        default:
            break;
    }
  
   
    
}

@end
