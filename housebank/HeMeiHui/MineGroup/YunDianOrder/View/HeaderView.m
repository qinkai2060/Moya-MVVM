//
//  HeaderView.m
//  demo
//
//  Created by 张磊 on 15/11/18.
//  Copyright © 2015年 张磊. All rights reserved.
//

#import "HeaderView.h"
#import "HeaderViewTableViewCell.h"
@interface HeaderView ()

@property (nonatomic, assign)    float widthTable;
@property (nonatomic, assign)   float heightTable;

@property (nonatomic, strong) UITableView *menuItemsTableView;
@property (nonatomic, strong) UIView *backView;

@end
@implementation HeaderView
- (void)setMenuItems:(NSArray *)menuItems{
    _menuItems = menuItems;
    [self.menuItemsTableView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems view:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = menuItems;
        self.backGroundButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.backGroundButton.backgroundColor = [UIColor clearColor];
        self.backView = view;
        [view addSubview:self.backGroundButton];

        
        self.menuItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, frame.size.width, frame.size.height - 6) style:(UITableViewStylePlain)];
        self.widthTable = frame.size.width;
        self.heightTable = frame.size.height - 10;
        self.menuItemsTableView.dataSource = self;
        self.menuItemsTableView.delegate = self;
        self.menuItemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuItemsTableView.bounces = NO;
        self.menuItemsTableView.scrollEnabled = YES;
        self.menuItemsTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        self.menuItemsTableView.layer.cornerRadius = 3;
        self.menuItemsTableView.layer.masksToBounds = YES;
        [self.menuItemsTableView registerClass:[HeaderViewTableViewCell class] forCellReuseIdentifier:@"cell"];
        self.menuItemsTableView.tag = 1000;
//        [UIView animateWithDuration:0.2f
//                         animations:^{
//                             self.menuItemsTableView.frame = CGRectMake(0, 10, frame.size.width, frame.size.height - 10);
//                         }
//                         completion:^(BOOL finished) {}];
        
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_upsj"]];
        [self addSubview:img];
        img.frame = CGRectMake(self.frame.size.width - 20, 0, 13, 6);
        
        
        [self addSubview:self.menuItemsTableView];
        
        [view addSubview:self];
    }
    
    
    return self;
}
#pragma mark UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 38;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuPopoverCell";
    
    HeaderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HeaderViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    if (self.menuItems.count - 1 == indexPath.row) {
        cell.line2.hidden = YES;
    } else {
        cell.line2.hidden = NO;
    }
    cell.label.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}
- (void)dismissMenuPopover
{
    [self hide];
}

- (void)showInView
{
    self.backGroundButton.frame = self.backView.bounds;
    
//    [UIView animateWithDuration:0.2f
//                     animations:^{
//                       self.menuItemsTableView.frame = CGRectMake(0, 10, self.widthTable, self.heightTable);
//                     }
//                     completion:^(BOOL finished) {
                         self.backGroundButton.hidden = NO;
                         self.hidden = NO;
//                     }];
    
}

- (void)hide
{
//    [UIView animateWithDuration:0.2f
//                     animations:^{
    
//                         self.menuItemsTableView.frame = CGRectMake(0, 10, self.widthTable, 0);
//                     }
//                     completion:^(BOOL finished) {
                         self.backGroundButton.hidden = YES;
                         self.hidden = YES;
//                     }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.hearderViewDelegate respondsToSelector:@selector(headerView: didSelectMenuItemAtIndex:)]) {
        [self.hearderViewDelegate headerView:self didSelectMenuItemAtIndex:indexPath.row
         ];
    }
    
    [self dismissMenuPopover];
}
@end
