//
//  RefreshTableView.m
//  xiala
//
//  Created by Dalink on 14-9-29.
//  Copyright (c) 2014年 Dalink. All rights reserved.
//
#define HEAT 40
#define TEXT_OFFSET_Y 60
#define DISTANCE 100
#define BAR_COLOR [UIColor whiteColor]
#define TEXT_SIZE 12

#import "RefreshTableView.h"
#import <Foundation/Foundation.h>

@interface RefreshTableView()
{
    UIActivityIndicatorView *topIndicator;
    UIView *_headerView;
    
    BOOL isInLoading;
    UILabel *topStateLabel;
    UIImageView *topImageView;
    
    UIActivityIndicatorView *bottomIndicator;
    UIView *_bottomView;
    //BOOL dragDistanceIsOver;
    UILabel *bottomStateLabel;
    UIImageView *bottomImageView;
}
@end

#define HEADER_NORMAL_TITLE @"下拉刷新"
#define HEADER_DRAGGING_TITLE @"松手刷新"
#define HEADER_LOADING_TITLE @"正在刷新"
#define FOOTER_NORMAL_TITLE @"拖动加载"
#define FOOTER_DRAGGING_TITLE @"松手加载"
#define FOOTER_LOADING_TITLE @"正在加载"

#define HEADER_NORMAL_TITLE_ENG @"Pull to refresh"
#define HEADER_DRAGGING_TITLE_ENG @"Release to refresh"
#define HEADER_LOADING_TITLE_ENG @"Refreshing"
#define FOOTER_NORMAL_TITLE_ENG @"Drag to load"
#define FOOTER_DRAGGING_TITLE_ENG @"Release to load"
#define FOOTER_LOADING_TITLE_ENG @"Loading"

@implementation RefreshTableView
- (id)init
{
    self = [self init];
    [self awakeFromNib];
    return self;
}
- (void)awakeFromNib
{
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        self.headerNormalTitle = HEADER_NORMAL_TITLE;
        self.headerDraggingTitle = HEADER_DRAGGING_TITLE;
        self.headerLoadingTitle = HEADER_LOADING_TITLE;
        self.footerNormalTitle = FOOTER_NORMAL_TITLE;
        self.footerDraggingTitle = FOOTER_DRAGGING_TITLE;
        self.footerLoadingTitle = FOOTER_LOADING_TITLE;
    }
    else
    {
        
        self.headerNormalTitle = HEADER_NORMAL_TITLE_ENG;
        self.headerDraggingTitle = HEADER_DRAGGING_TITLE_ENG;
        self.headerLoadingTitle = HEADER_LOADING_TITLE_ENG;
        self.footerNormalTitle = FOOTER_NORMAL_TITLE_ENG;
        self.footerDraggingTitle = FOOTER_DRAGGING_TITLE_ENG;
        self.footerLoadingTitle = FOOTER_LOADING_TITLE_ENG;
    }
    self.draggingThredshold = DISTANCE;
    self.headerBackgroundColor = BAR_COLOR;
    self.footerBackgroundColor = BAR_COLOR;
    
    [self setOnWidgets];
    [self setOnObserver];
    
    [self setTopRefreshEnabled:YES];
    [self setBottomRefreshEnabled:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        CGSize size = self.contentSize;
        CGRect frame = self.frame;
        if (size.height > frame.size.height)
        {
            [_bottomView setFrame:CGRectMake(0, size.height, frame.size.width, frame.size.height)];
        }
        else
        {
            [_bottomView setFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
        }
    }
    if ([keyPath isEqualToString:@"topRefreshEnabled"])
    {
        [_headerView setHidden:!self.topRefreshEnabled];
    }
    if ([keyPath isEqualToString:@"bottomRefreshEnabled"])
    {
        [_bottomView setHidden:!self.bottomRefreshEnabled];
    }
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:self];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isInLoading)
    {
        return;
    }
    int contentSizeHeight = self.contentSize.height;
    CGPoint offset = [self contentOffset];
    if (self.topRefreshEnabled)
    {
        //enough distance to refresh top
        if (offset.y < -_draggingThredshold)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [topStateLabel setText:_headerDraggingTitle];
            [topImageView setTransform:CGAffineTransformMakeRotation((180.0f*3.14)/180)];
            [UIView commitAnimations];
        }
        //top drag distances is deficit
        if (offset.y > -_draggingThredshold && offset.y < 0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [topStateLabel setText:_headerNormalTitle];
            [topImageView setTransform:CGAffineTransformIdentity];
            [UIView commitAnimations];
        }
    }
    if (self.bottomRefreshEnabled)
    {
        //enough distance to refresh bottom
        int jiaozheng = 0;
        if (self.frame.size.height < contentSizeHeight)
        {
            jiaozheng = contentSizeHeight - self.frame.size.height;
        }
        else
        {
            jiaozheng = 0;
        }
        if (offset.y -jiaozheng > _draggingThredshold)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [bottomStateLabel setText:_footerDraggingTitle];
            [bottomImageView setTransform:CGAffineTransformMakeRotation((180.0f*3.14)/180)];
            [UIView commitAnimations];
        }
        // bottom drag distances is deficit
        if (offset.y - jiaozheng < _draggingThredshold && offset.y -jiaozheng > 0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [bottomStateLabel setText:_footerNormalTitle];
            [bottomImageView setTransform:CGAffineTransformIdentity];
            [UIView commitAnimations];
        }
    }
    
    if (!self.isDragging)
    {
        [self scrollViewDidEndDragging];
    }
}

- (void)loadOver
{
    isInLoading = NO;
    [topIndicator stopAnimating];
    [topStateLabel setText:_headerNormalTitle];
    [bottomIndicator stopAnimating];
    [bottomStateLabel setText:_footerNormalTitle];
    [UIView beginAnimations:nil context:nil];
    [self setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [UIView setAnimationDuration:2];
    [UIView commitAnimations];
    [topImageView setHidden:NO];
    [bottomImageView setHidden:NO];
    [_headerView setHidden:!self.topRefreshEnabled];
    [_bottomView setHidden:!self.bottomRefreshEnabled];
}

- (void)scrollViewDidEndDragging
{
    if (!isInLoading)
    {
        CGPoint offset = [self contentOffset];
        //top refresh
        if (offset.y < -_draggingThredshold && self.topRefreshEnabled)
        {
            //dragDistanceIsOver = YES;
            [topIndicator startAnimating];
            isInLoading = true;
            if ([_refreshDelegate respondsToSelector:@selector(refreshTableViewTopRefresh:)])
            {
                [_refreshDelegate performSelector:@selector(refreshTableViewTopRefresh:) withObject:self];
            }
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [self setContentInset:UIEdgeInsetsMake(HEAT, 0, 0, 0)];
            [UIView commitAnimations];
            [topStateLabel setText:_headerLoadingTitle];
            [_bottomView setHidden:YES];
            [topImageView setTransform:CGAffineTransformIdentity];
            [topImageView setHidden:YES];
        }
        //bottom refresh
        int jiaozheng = 0;
        int contentSizeHeight = self.contentSize.height;
        if (self.frame.size.height < contentSizeHeight)
        {
            jiaozheng = contentSizeHeight - self.frame.size.height;
        }
        else
        {
            jiaozheng = 0;
        }
        if ((offset.y -jiaozheng > _draggingThredshold)&&self.bottomRefreshEnabled)
        {
            //dragDistanceIsOver = YES;
            [bottomIndicator startAnimating];
            isInLoading = true;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [self setContentInset:UIEdgeInsetsMake(0, 0, HEAT, 0)];
            [UIView commitAnimations];
            [bottomStateLabel setText:_footerLoadingTitle];
            [_headerView setHidden:YES];
            [bottomImageView setTransform:CGAffineTransformIdentity];
            [bottomImageView setHidden:YES];
            if ([_refreshDelegate respondsToSelector:@selector(refreshTableViewBottomRefresh:)])
            {
                [_refreshDelegate performSelector:@selector(refreshTableViewBottomRefresh:) withObject:self afterDelay:0.6];
            }
        }
        
    }
}
- (void)setOnWidgets
{
    CGRect frame = self.bounds;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    frame.origin.y = -frame.size.height;
    
    _headerView = [[UIView alloc] initWithFrame:frame];
    [_headerView setBackgroundColor:_headerBackgroundColor];
    topStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [topStateLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height - HEAT/2)];
    [topStateLabel setText:_headerNormalTitle];
    [topStateLabel setFont:[UIFont systemFontOfSize:TEXT_SIZE]];
    [topStateLabel setTextAlignment:NSTextAlignmentCenter];
    [_headerView addSubview:topStateLabel];
    topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xialajiantou_03.png"]];
    [topImageView setBounds:CGRectMake(0, 0, 20, 20)];
    [topImageView setCenter:CGPointMake(frame.size.width/2 - TEXT_OFFSET_Y, frame.size.height - HEAT/2)];
    [_headerView addSubview:topImageView];
    
    topIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [topIndicator setCenter:CGPointMake(frame.size.width/2-TEXT_OFFSET_Y, frame.size.height - HEAT/2)];
    [_headerView addSubview:topIndicator];
    [topIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_headerView];
    
    
    frame = self.bounds;
    frame.origin.y = frame.size.height;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    
    _bottomView = [[UIView alloc] initWithFrame:frame];
    [_bottomView setBackgroundColor:_footerBackgroundColor];
    bottomStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [bottomStateLabel setCenter:CGPointMake(frame.size.width/2, HEAT/2)];
    [bottomStateLabel setText:_footerNormalTitle];
    [bottomStateLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomStateLabel setFont:[UIFont systemFontOfSize:TEXT_SIZE]];
    [_bottomView addSubview:bottomStateLabel];
    
    bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shanglajiantou_03.png"]];
    [bottomImageView setBounds:CGRectMake(0, 0, 20, 20)];
    [bottomImageView setCenter:CGPointMake(frame.size.width/2-TEXT_OFFSET_Y, HEAT/2)];
    [_bottomView addSubview:bottomImageView];
    
    bottomIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [bottomIndicator setCenter:CGPointMake(frame.size.width/2-TEXT_OFFSET_Y, HEAT/2)];
    [bottomIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_bottomView addSubview:bottomIndicator];
    [self addSubview:_bottomView];
    
}

- (void)setOnObserver
{
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    //view contentoffset, to display animation
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"topRefreshEnabled" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"bottomRefreshEnabled" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserver
{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"topRefreshEnabled"];
    [self removeObserver:self forKeyPath:@"bottomRefreshEnabled"];
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

- (void)dealloc
{
    [self removeObserver];
}
@end