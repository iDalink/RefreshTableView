//
//  ViewController.m
//  testtableview
//
//  Created by Dalink on 15-1-12.
//  Copyright (c) 2015年 Dalink. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *coreData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    coreData = @[@"New York", @"Chigago", @"Los", @"Sanf", @"New York", @"Chigago", @"Los", @"Sanf", @"New York", @"Chigago", @"Los", @"Sanf", @"New York", @"Chigago", @"Los", @"Sanf"];
    [_refreshTableView setRefreshDelegate:self];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return coreData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = coreData[indexPath.row];
    return cell;
}

- (void)refreshTableViewTopRefresh:(RefreshTableView *)tableView
{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerTimeOut) userInfo:nil repeats:NO];
    [timer timeInterval];
}

- (void)refreshTableViewBottomRefresh:(RefreshTableView *)tableView
{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerTimeOut) userInfo:nil repeats:NO];
    
    [timer timeInterval];
}

- (void)timerTimeOut
{
    [_refreshTableView loadOver];
}
@end
