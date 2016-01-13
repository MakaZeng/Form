//
//  SchoolCellView.m
//  FormApplication
//
//  Created by Maka on 15/11/13.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "SchoolCellView.h"

@interface SchoolCellView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIView* rootContainerView;

@property (nonatomic,strong) UIView* backView;

@property (nonatomic,copy) schoolChooseCellViewBlock block;

@property (nonatomic,strong) NSArray* dataSource;

@property (nonatomic,strong) NSArray* schoolList;

@end

@implementation SchoolCellView

+(instancetype)showSchoolChooseCellViewWithBlock:(schoolChooseCellViewBlock)block withInfo:(NSDictionary *)info
{
    UIView* container = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = [UIColor clearColor];
    
    UIView* backView = [[UIView alloc]initWithFrame:container.bounds];
    backView.alpha = 0;
    backView.backgroundColor = [UIColor blackColor];
    [container addSubview:backView];
    
    SchoolCellView* v = [SchoolCellView instanceFromNib];
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
    v.block = block;
    v.info = info;
    NSArray *schools = [info objectForKey:@"data"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *school in schools)
    {
        [array addObject:school[@"name"]];
    }
    v.schoolList = [NSArray arrayWithArray:array];
    v.dataSource = v.schoolList;
    [v.textField becomeFirstResponder];
    return v;
}

-(void)hide
{
    [self.rootContainerView removeFromSuperview];
    self.rootContainerView = nil;
}

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SchoolCellView" owner:self options:nil] firstObject];
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
    self.textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (IBAction)editingChange:(id)sender {
    UITextRange *selectedRange = [self.textField markedTextRange];
    NSString * newText = [self.textField textInRange:selectedRange];    //获取高亮部分
    if(newText.length>0) return;
    
    [self textChanged:self.textField.text];
}

- (void)textChanged:(NSString *)text
{
    if (text == nil)
    {
        return;
    }
    text = [NSString stringWithFormat:@"*%@*", text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", text];
    self.dataSource = [self.schoolList filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)keyboardChangeFrame:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    CGRect bounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect targetFrame = self.frame;
    if (self.frame.origin.y + self.frame.size.height + 10 >([UIScreen mainScreen].bounds.size.height - bounds.size.height)) {
        targetFrame.origin.y = [UIScreen mainScreen].bounds.size.height - bounds.size.height - self.frame.size.height - 10;
    }
    if (targetFrame.origin.y <= 10) {
        targetFrame.origin.y = 10;
        targetFrame.size.height = [UIScreen mainScreen].bounds.size.height - 20 -bounds.size.height;
    }
    
    if (targetFrame.origin.y+targetFrame.size.height +40 < [UIScreen mainScreen].bounds.size.height -bounds.size.height) {
        targetFrame.origin.y = [UIScreen mainScreen].bounds.size.height -bounds.size.height -40 -targetFrame.size.height;
    }
    
    [UIView animateWithDuration:.1 animations:^{
        self.frame = targetFrame;
    }];
    
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* iden = @"iden";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    id selectedItem = self.dataSource[indexPath.row];
    cell.textLabel.text = selectedItem;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selectedItem = self.dataSource[indexPath.row];
    if (self.block) {
        self.block(selectedItem);
        [self hide];
    }
}


@end
