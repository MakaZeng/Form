//
//  FormTableViewController.m
//  TestForm
//
//  Created by caoyusheng on 28/8/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "FormTableViewController.h"
#import <objc/runtime.h>
#import "FormTag.h"
#import "BaseFormCell.h"

@interface FormTableViewController()<BaseFormCellDelegate>

@property(strong, nonatomic) NSMutableArray *formDefine; //从 plist 读取到的 数据

@property (nonatomic,strong,readwrite) NSMutableDictionary* formDictionary;//表格对应数据 随着内容修改而修改

@end

@implementation FormTableViewController

- (void) viewDidLoad
{
    //加载plist文件
    [self loadDataFromPlist];
    
    //附加视图加载
    [self setupUserInterface];
    
    //加载表格初始化数据
    [self refreshFormData];
}

-(void)setupUserInterface
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"BottomView" owner:self options:nil];
    self.tableView.tableFooterView = [array firstObject];
    UIButton *button = (UIButton *)[self.tableView.tableFooterView viewWithTag:100];
    [button addTarget:self action:@selector(sumit) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.autoresizesSubviews = NO;
}

-(BOOL)check
{
    return YES;
}

-(void) sumit
{
    
}

-(void)loadDataFromPlist
{
    NSString* fileName = [NSString stringWithUTF8String:object_getClassName(self)];
    self.formDefine = [[NSMutableArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
    if (![self.formDefine isKindOfClass:[NSArray class]]) {
        self.formDefine = nil;
    }
}

-(NSDictionary* )loadRemoteData
{
    NSMutableDictionary* remoteInfo = [[NSMutableDictionary alloc]init];
    remoteInfo[@"name"] = @"啦啦啦";
    remoteInfo[@"cn_card"] = @"140109198305210018";
    remoteInfo[@"qq"] = @"72885722277";
    remoteInfo[@"married"] = @1;
    remoteInfo[@"degree"] = @2;
    remoteInfo[@"school"] = @1;
    return [remoteInfo copy];
}

-(void)refreshFormData
{
    //获取到远程的初始数据
    NSDictionary* remoteInfo = [self loadRemoteData];
    
    //将远程数据拷贝到本地form字典中
    self.formDictionary = [remoteInfo mutableCopy];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self getDisplayCount:self.formDefine];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getDisplayCount:self.formDefine[section][form_content]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.formDefine[indexPath.section][form_content][indexPath.row];
    return [BaseFormCell heightForDictionary:dic];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.formDefine[indexPath.section][form_content][indexPath.row];
    
    BaseFormCell* cell = [BaseFormCell instanceForDictionary:dic withTableView:tableView forIndexPath:indexPath withDelegate:self withTargetDic:(id)self.formDictionary];
    
    return cell;
}


- (NSInteger) getDisplayCount:(NSArray *)array
{
    NSInteger count = 0;
    for (int i = 0; i < array.count; i++)
    {
        NSMutableDictionary *dic = array[i];
        if (!dic[form_display])
        {
            dic[form_display] = @(YES);
        }
        count += [dic[form_display] boolValue] ? 1 : 0;
    }
    return count;
}

#pragma mark - BaseFormCellDelegate

-(void)baseFormCellNextStep:(BaseFormCell *)cell
{
    NSIndexPath * path = cell.indexPath;
    
    NSInteger section = path.section;
    NSInteger row = path.row + 1;
    
    if (row == [_formDefine[section][form_content] count])
    {
        section++;
        row = 0;
    }
    [cell resignFirstResponder];
    if (section == [_formDefine count])
    {
        return;
    }else
    {
        NSIndexPath *nextPath = [NSIndexPath indexPathForRow:row inSection:section];
        BaseFormCell *nextCell = (BaseFormCell *)[self.tableView cellForRowAtIndexPath:nextPath];
        [nextCell becomeFirstResponder];
    }
}

@end
