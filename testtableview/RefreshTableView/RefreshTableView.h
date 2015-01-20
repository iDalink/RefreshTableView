//
//  RefreshTableView.h
//  xiala
//
//  Created by Dalink on 14-9-29.
//  Copyright (c) 2014年 Dalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableViewDelegate.h"

@interface RefreshTableView : UITableView<UIScrollViewDelegate>

@property (nonatomic, weak) NSObject<RefreshTableViewDelegate> *refreshDelegate;

/*  determines whether dragging to top is enable
 *  default is YES
 */

@property (nonatomic) bool topRefreshEnabled;


/*  determines whether dragging to bottom is enable
 *  default is YES
 */

@property (nonatomic) bool bottomRefreshEnabled;


/*  the header and footer view will show titles
 *  you can specify the words by setting following variables
 */
@property (nonatomic) NSString *headerNormalTitle;
@property (nonatomic) NSString *headerDraggingTitle;
@property (nonatomic) NSString *headerLoadingTitle;
@property (nonatomic) NSString *footerNormalTitle;
@property (nonatomic) NSString *footerDraggingTitle;
@property (nonatomic) NSString *footerLoadingTitle;

/*  'draggingThredshold' determines the dragging sensitivity of the trigger
 */
@property (nonatomic) int draggingThredshold;

/*  the footer and header views have their background color
 *  obviously, you can specify the attribute
 */

@property (nonatomic) UIColor *headerBackgroundColor;
@property (nonatomic) UIColor *footerBackgroundColor;


/*  after updating to the new content, send a 'loadOver' message to stop the widget from loading.
 *  while loading, the tableview will have applicable edges to accommodate header or footer，
 *  and an UIActivityIndicator will be animating.
 *  call 'loadOver',the edges will disappear and the indicator will stop
 */

- (void)loadOver;

@end