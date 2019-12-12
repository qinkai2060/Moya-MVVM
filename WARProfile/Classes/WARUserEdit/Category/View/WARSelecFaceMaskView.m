//
//  WARSelecFaceMaskView.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/27.
//

#import "WARSelecFaceMaskView.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARBaseMacros.h"

#import "WARFaceMaskModel.h"

@implementation WARSelecFaceMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self setUI];
        [self setLayout];
//        self.selectRow = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
        self.tag = 1000;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setGroupArr:(NSArray *)groupArr{
    _groupArr = groupArr;
    CGFloat navH = 160+ (WAR_IS_IPHONE_X?20:0);
    CGFloat corNerH = (self.groupArr.count+2)*45;
    CGFloat ScorllH = (self.groupArr.count)*45;
    if(corNerH>=360){
        corNerH = 360;
        ScorllH = 270;
    }
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(48);
        make.right.equalTo(self).offset(-48);
        make.centerY.equalTo(self);
        make.height.equalTo(@(corNerH));
    }];
    [self.titleLabei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.cornerView);
        make.height.equalTo(@45);
    }];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabei.mas_bottom);
        make.left.right.equalTo(self.cornerView);
        make.height.equalTo(@(ScorllH));
        
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tbView.mas_bottom);
        make.left.right.equalTo(self.cornerView);
        make.height.equalTo(@45);
    }];
    [self.tbView reloadData];
}
- (void)setUI{
    [self addSubview:self.cornerView];
    [self.cornerView addSubview:self.titleLabei];
    [self.cornerView addSubview:self.tbView];
    [self.cornerView addSubview:self.sureBtn];
}
- (void)setLayout{
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.cornerView] ) {
        return NO;
    }else{
        return YES;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARFaceMaskModel *model = self.groupArr[indexPath.row];
    
    WARSelecFaceMaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[WARSelecFaceMaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (self.isSelectRow) {
        if (self.selectRow == indexPath.row) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
    }

    [cell setData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.isSelectRow = YES;
//    self.selectRow = indexPath.row;
}

- (void)selectClick:(UIButton*)v{
    self.isSelectRow = YES;
    WARSelecFaceMaskCell *cell =  v.superview.superview;
    NSIndexPath *index = [self.tbView indexPathForCell:cell];
    self.selectRow = index.row;
    [self.tbView reloadData];
}


- (UIView *)cornerView{
    if (!_cornerView){
        _cornerView = [[UIView alloc] init];
        _cornerView.backgroundColor = [UIColor whiteColor];
        _cornerView.layer.cornerRadius = 13;
        _cornerView.layer.masksToBounds = YES;
    }
    return _cornerView;
}
- (UITableView *)tbView{
    if (!_tbView){
        _tbView = [[UITableView alloc] init];
        _tbView.dataSource = self;
        _tbView.delegate = self;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.scrollEnabled = NO;
    }
    return _tbView;
}
- (UILabel *)titleLabei{
    if (!_titleLabei){
        _titleLabei = [[UILabel alloc] init];
        _titleLabei.textColor = [UIColor blackColor];
        _titleLabei.textAlignment = NSTextAlignmentCenter;
        _titleLabei.font = [UIFont boldSystemFontOfSize:18];
        _titleLabei.text =WARLocalizedString(@"加入分组");
    }
    return _titleLabei;
}
- (UIButton *)sureBtn{
    if (!_sureBtn){
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"01d8b7"] forState:UIControlStateNormal];
        [_sureBtn setTitle:WARLocalizedString(@"确定") forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (void)removeView:(UITapGestureRecognizer*)tap{
    if (tap.view.tag == 1000) {
        [self removeAlert];
    }
    
}
- (void)sureClick:(UIButton*)btn{
    
    WARFaceMaskModel *model = self.groupArr[self.selectRow];

    if (self.sureBlock) {
        self.sureBlock(model.faceId);
        [self removeAlert];
    }
    
}
- (void)removeAlert{
    UIView *V = self;
    [V removeFromSuperview];
    V = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end





@implementation WARSelecFaceMaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUI];
        [self setLayout];
        
    }
    return self;
}
- (void)setUI
{
    [self.contentView addSubview:self.titlelb];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.lineView];
    
}
- (void)setData:(WARFaceMaskModel*)model{
    self.titlelb.text = model.faceName;

}
- (void)setLayout
{
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.height.equalTo(@60);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2.5);
        make.right.equalTo(self.contentView).offset(-6);
        make.width.height.equalTo(@40);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(44);
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
        make.height.equalTo(@1);
    }];
}
- (UILabel *)titlelb{
    if (!_titlelb){
        _titlelb = [[UILabel alloc] init];
        _titlelb.textColor = [UIColor blackColor];
        _titlelb.font = [UIFont systemFontOfSize:15];
    }
    return _titlelb;
}
- (UIButton *)selectBtn{
    if(!_selectBtn){
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage war_imageName:@"choose" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage war_imageName:@"choose_pre" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
    }
    return _selectBtn;
}
- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end

