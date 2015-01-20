//
//  ViewController.h
//  testtableview
//
//  Created by Dalink on 15-1-12.
//  Copyright (c) 2015年 Dalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>

@property (nonatomic) IBOutlet RefreshTableView *refreshTableView;


@end

