//
//  ViewController.m
//  FFPagingViewDemo
//
//  Created by Jacqui on 16/9/27.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import "ViewController.h"
#import "FFPagingViewController.h"

#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kHeaderViewTop      40

@interface ViewController () <FFPagingViewControllerDataSource, FFPagingViewControllerDelegate>
@property(nonatomic, strong) FFPagingViewController *pagingViewController;
@property(nonatomic, strong) FFPagingHeaderView *pagingHeaderView;

@property(nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ViewController

#pragma mark - init
- (void)setupView
{
    self.title = @"PagingDemo";
    
    [self.view addSubview:self.pagingHeaderView];
    WS(weakSelf);
    self.pagingHeaderView.pagingViewItemClickHandle = ^(FFPagingHeaderView *headerView, NSString *title, NSInteger currentIndex) {
        weakSelf.pagingViewController.seletedIndex = currentIndex;
    };
    
    [self.view addSubview:self.pagingViewController.view];
    [self.pagingViewController reloadData];
}

- (void)setupData
{
    //创建controller
    for (NSInteger i=0; i<3; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = LRRandomColor;
        [self.viewControllers addObject:vc];
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupData];
    [self setupView];
}

- (void)viewDidLayoutSubviews
{
    self.pagingViewController.view.frame = CGRectMake(0, kHeaderViewTop, self.view.frame.size.width, self.view.frame.size.height- kHeaderViewTop);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FFPagingViewControllerDelegate
- (void)customPagingViewController:(FFPagingViewController *)pagingViewController slideIndex:(NSInteger)slideIndex
{
    [self.pagingHeaderView updateTitleContentOffset:slideIndex];
}

- (void)customPagingViewController:(FFPagingViewController *)pagingViewController contentOffset:(CGPoint)slideOffset
{
    self.pagingHeaderView.contentOffset = slideOffset;
}

#pragma mark - FFPagingViewControllerDataSource
- (NSUInteger)numberOfChildViewControllersInPagingViewController:(FFPagingViewController *)pagingViewController
{
    return self.viewControllers.count;
}

- (UIViewController *)pagingViewController:(FFPagingViewController *)pageingViewController atIndex:(NSInteger)index
{
    return self.viewControllers[index];
}

#pragma mark - getter
- (FFPagingViewController *)pagingViewController
{
    if (!_pagingViewController) {
        _pagingViewController = [[FFPagingViewController alloc] init];
        _pagingViewController.delegate = self;
        _pagingViewController.dataSource = self;
    }
    return _pagingViewController;
}

- (FFPagingHeaderView *)pagingHeaderView
{
    if (!_pagingHeaderView) {
        _pagingHeaderView = [[FFPagingHeaderView alloc] init];
        _pagingHeaderView.backgroundColor = [UIColor whiteColor];
        _pagingHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeaderViewTop);
        _pagingHeaderView.itemWidth = 80;
        //        _pagingHeaderView.scale = true;
        _pagingHeaderView.titles = @[@"热门", @"美女", @"精选"];
    }
    return _pagingHeaderView;
}

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

@end
