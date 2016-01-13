//
//  ActionSheetCellView.m
//  wolaidai
//
//  Created by Maka on 15/11/11.
//  Copyright © 2015年 welab. All rights reserved.
//

#import "ActionSheetCellView.h"

@interface ActionSheetCellView ()

@property (nonatomic,weak) UIView* rootContainerView;

@property (nonatomic,strong) UIView* backView;

@property (nonatomic,strong) id info;

@end

@implementation ActionSheetCellView

+(instancetype)showActionSheetWithInfo:(id)info title:(NSString*)titleString selectedBlock:(showActionSheetBlock)showBlock
{
    UIView* container = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = [UIColor clearColor];
    UIView* backView = [[UIView alloc]initWithFrame:container.bounds];
    backView.alpha = 0;
    backView.backgroundColor = [UIColor blackColor];
    [container addSubview:backView];
    
    ActionSheetCellView* v = [ActionSheetCellView instanceFromNib];
    v.center = CGPointMake(backView.bounds.size.width/2, backView.bounds.size.height/2);
    
    v.transform = CGAffineTransformMakeScale(.1, .1);
    v.backView = backView;
    v.rootContainerView = container;
    [container addSubview:v];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:v action:@selector(hide)];
    [backView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:container];
    
    [UIView animateWithDuration:.25 animations:^{
        backView.alpha = .5;
        v.transform = CGAffineTransformIdentity;
    }];
    v.titleLabel.text= titleString;
    v.info = info;
    v.showBlock = showBlock;
    return v;
}

-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.backView.alpha = 0;
        self.transform = CGAffineTransformMakeScale(.1, .1);
    } completion:^(BOOL finished) {
        [self.rootContainerView removeFromSuperview];
        self.rootContainerView = nil;
        self.backView = nil;
    }];
}

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ActionSheetCellView" owner:self options:nil] firstObject];
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceHorizontal = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.info isKindOfClass:[NSArray class]]) {
        return [self.info count];
    }else if ([self.info isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [self.info objectForKey:@"data"];
        if ([array isKindOfClass:[NSArray class]]) {
            return array.count;
        }
    }
    return 0;
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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if ([self.info isKindOfClass:[NSArray class]]) {
        NSDictionary* dic = [(NSArray*)self.info objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"name"];
    }else if ([self.info isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [self.info objectForKey:@"data"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSDictionary* dic = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"name"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showBlock) {
        if ([self.info isKindOfClass:[NSArray class]]) {
            NSDictionary* dic = [(NSArray*)self.info objectAtIndex:indexPath.row];
            self.showBlock(NO,dic);
            [self hide];
        }else if ([self.info isKindOfClass:[NSDictionary class]])
        {
            NSArray* array = [self.info objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSDictionary* dic = [array objectAtIndex:indexPath.row];
                self.showBlock(NO,dic);
                [self hide];
            }
        }
    }
}

@end
