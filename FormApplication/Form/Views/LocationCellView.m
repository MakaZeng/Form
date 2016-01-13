//
//  LocationCellView.m
//  FormApplication
//
//  Created by Maka on 15/11/16.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "LocationCellView.h"

@interface LocationCellView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *backTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) LocationCellViewBlock block;

@property (nonatomic,weak) UIView* rootContainerView;

@property (nonatomic,strong) UIView* backView;

@property (nonatomic,strong) id info;

@property (nonatomic,assign) NSInteger deepth;

@property (nonatomic,strong) NSArray* currentArray;

@property (nonatomic,strong) NSMutableArray* dataSourceStack;

@property (nonatomic,strong) NSMutableArray* chooseAreaStack;

@end

@implementation LocationCellView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceHorizontal = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.dataSourceStack = [NSMutableArray array];
    self.chooseAreaStack = [NSMutableArray array];
}

+(instancetype)showLocationCellViewWithInfo:(id)info callBack:(LocationCellViewBlock)block title:(NSString *)title
{
    UIView* container = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = [UIColor clearColor];
    UIView* backView = [[UIView alloc]initWithFrame:container.bounds];
    backView.alpha = 0;
    backView.backgroundColor = [UIColor blackColor];
    [container addSubview:backView];
    
    LocationCellView* v = [LocationCellView instanceFromNib];
    v.frame = CGRectMake(0, container.bounds.size.height, container.bounds.size.width, container.bounds.size.height-200);
    
    v.backView = backView;
    v.rootContainerView = container;
    [container addSubview:v];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:v action:@selector(hide)];
    [backView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:container];
    
    [UIView animateWithDuration:.25 animations:^{
        backView.alpha = .5;
        v.frame= CGRectMake(0, container.bounds.size.height-v.frame.size.height, v.frame.size.width, v.frame.size.height);
    }];
    v.titleLabel.text= title;
    v.info = info;
    v.currentArray = [v.info objectForKey:@"areas"];
    v.block = block;
    return v;
}

-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.backView.alpha = 0;
        CGRect frame = self.frame;
        frame.origin.y = self.rootContainerView.bounds.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.rootContainerView removeFromSuperview];
        self.rootContainerView = nil;
        self.backView = nil;
    }];
}

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LocationCellView" owner:self options:nil] firstObject];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* iden = @"iden";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    NSDictionary* dic = [(NSArray*)self.currentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [self.currentArray objectAtIndex:indexPath.row];
    if ([dic objectForKey:@"areas"]) {
        
        if ([self.dataSourceStack count]>self.deepth) {
            [self.dataSourceStack replaceObjectAtIndex:self.deepth withObject:self.currentArray];
            [self.chooseAreaStack replaceObjectAtIndex:self.deepth withObject:dic];
        }else {
            [self.dataSourceStack addObject:self.currentArray];
            [self.chooseAreaStack addObject:dic];
        }
        
        self.deepth += 1;
        self.backTitleLabel.hidden = NO;
        self.currentArray = [dic objectForKey:@"areas"];
        [self.tableView reloadData];
        CATransition *animation = [CATransition animation];
        [animation setDuration:.25];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setType:@"moveIn"];
        [animation setSubtype:kCATransitionFromRight];
        [self.tableView.layer addAnimation:animation forKey:nil];
        
    }else {
        [self.chooseAreaStack addObject:dic];
        if (self.block) {
            self.block(self.chooseAreaStack);
            [self hide];
        }
    }
}

- (IBAction)backAction:(id)sender {
    if (!self.backTitleLabel.hidden) {
        self.deepth -= 1;
        self.currentArray = self.dataSourceStack[self.deepth];
        [self.tableView reloadData];
        CATransition *animation = [CATransition animation];
        [animation setDuration:.25];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setType:@"reveal"];
        [animation setSubtype:kCATransitionFromLeft];
        [self.tableView.layer addAnimation:animation forKey:nil];
    }
    if (self.deepth == 0) {
        self.backTitleLabel.hidden = YES;
    }
}

@end
