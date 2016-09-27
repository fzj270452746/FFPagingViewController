//
//  FFPagingViewController.h
//  BasicFrameworkManager
//
//  Created by Fan on 16/9/26.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFPagingHeaderView.h"

@class FFPagingViewController;

@protocol FFPagingViewControllerDelegate <NSObject>
- (void)customPagingViewController:(FFPagingViewController *)pagingViewController slideIndex:(NSInteger)slideIndex;
- (void)customPagingViewController:(FFPagingViewController *)pagingViewController contentOffset:(CGPoint)slideOffset;
@end

@protocol FFPagingViewControllerDataSource <NSObject>
@required
- (NSUInteger)numberOfChildViewControllersInPagingViewController:(FFPagingViewController *)pagingViewController;
- (UIViewController *)pagingViewController:(FFPagingViewController *)pageingViewController atIndex:(NSInteger)index;
@end

@interface FFPagingViewController : UIViewController
@property(nonatomic, weak) id <FFPagingViewControllerDelegate> delegate;
@property(nonatomic, weak) id <FFPagingViewControllerDataSource> dataSource;
@property (nonatomic, assign) NSInteger seletedIndex;

//首次需调用该方法
- (void)reloadData;
@end
