//
//  RefreshTableViewDelegate.h
//  xiala
//
//  Created by Dalink on 14-9-29.
//  Copyright (c) 2014年 Dalink. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RefreshTableView;
@protocol RefreshTableViewDelegate <NSObject>
@optional
- (void)refreshTableViewTopRefresh:(RefreshTableView *)_tableView;
- (void)refreshTableViewBottomRefresh:(RefreshTableView *)_tableView;
@end
