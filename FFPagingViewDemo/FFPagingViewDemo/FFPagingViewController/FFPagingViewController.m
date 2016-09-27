//
//  FFPagingViewController.m
//  BasicFrameworkManager
//
//  Created by Fan on 16/9/26.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import "FFPagingViewController.h"

#define kViewControllerCount    5

@interface FFPagingViewController () <UIScrollViewDelegate>
@property(nonatomic, weak) UIScrollView *scrollview;
@property(nonatomic, strong) NSMutableDictionary *displayVcs;
@property(nonatomic, strong) NSMutableDictionary *memoryCache;
@end

@implementation FFPagingViewController
#pragma mark - init
- (void)initializedViewControllerAtIndex:(NSInteger)index
{
    UIViewController *vc = [self.memoryCache objectForKey:@(index)];
    if (!vc) {
        if ([self.dataSource respondsToSelector:@selector(pagingViewController:atIndex:)]) {
            UIViewController *childVC = [self.dataSource pagingViewController:self atIndex:index];
            [self addChildViewController:childVC atIndex:index];
        }
    } else {
        [self addChildViewController:vc atIndex:index];
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.scrollview.frame = self.view.bounds;
    self.scrollview.contentSize = CGSizeMake([self childViewControllerCount] * self.scrollview.frame.size.width, self.scrollview.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [self.displayVcs removeAllObjects];
    [self.memoryCache removeAllObjects];
    
    for (NSInteger i=0; i<self.childViewControllers.count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
    
    self.scrollview.frame = self.view.frame;
    self.scrollview.contentSize = CGSizeMake([self childViewControllerCount] * self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    [self scrollViewDidScroll:self.scrollview];
}

- (NSInteger)childViewControllerCount
{
    if ([self.dataSource respondsToSelector:@selector(numberOfChildViewControllersInPagingViewController:)]) {
        return [self.dataSource numberOfChildViewControllersInPagingViewController:self];
    }
    return 0;
}

//添加子视图控制器view到scrollview上，并放入正在展示的controller中
- (void)addChildViewController:(UIViewController *)childController atIndex:(NSInteger)index
{
    if ([self.childViewControllers containsObject:childController]) {
        return;
    }
    
    [self addChildViewController:childController];
    [self.displayVcs setObject:childController forKey:@(index)];
    [childController didMoveToParentViewController:self];
    [self.scrollview addSubview:childController.view];
    childController.view.frame = CGRectMake(index * [UIScreen mainScreen].bounds.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
}

- (void)removeChildViewController:(UIViewController *)childController atIndex:(NSInteger)index
{
    if (!childController) {
        return;
    }
    
    //将未展示的controller从父视图及父controller中移除
    [childController.view removeFromSuperview];
    [childController didMoveToParentViewController:nil];
    [childController removeFromParentViewController];
    
    //将controller从之前用于存储展示的数据中移除，并且添加到缓存中
    [self.displayVcs removeObjectForKey:@(index)];
    if (![self.memoryCache objectForKey:@(index)]) {
        [self.memoryCache setObject:childController forKey:@(index)];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
    NSInteger start = currentPage == 0 ? currentPage : (currentPage - 1);
    NSInteger end = currentPage == ([self childViewControllerCount] - 1) ? currentPage : (currentPage + 1);
    
    for (NSInteger i = start; i<=end; i++) {
        UIViewController *vc = [self.displayVcs objectForKey:@(i)];
        if (!vc) {
            [self initializedViewControllerAtIndex:i];
        }
    }
    
    //将当前显示视图位置-1前的controller移除
    for (NSInteger i=0; i< start; i++) {
        UIViewController *vc = [self.displayVcs objectForKey:@(i)];
        [self removeChildViewController:vc atIndex:i];
    }
    
    for (NSInteger i=end+1; i<= [self childViewControllerCount]-1; i++) {
        UIViewController *vc = [self.displayVcs objectForKey:@(i)];
        [self removeChildViewController:vc atIndex:i];
    }
    
    if ([self.delegate respondsToSelector:@selector(customPagingViewController:contentOffset:)]) {
        [self.delegate customPagingViewController:self contentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(customPagingViewController:contentOffset:)]) {
        [self.delegate customPagingViewController:self contentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(customPagingViewController:slideIndex:)]) {
        [self.delegate customPagingViewController:self slideIndex:scrollView.contentOffset.x/self.scrollview.frame.size.width];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(customPagingViewController:contentOffset:)]) {
        [self.delegate customPagingViewController:self contentOffset:scrollView.contentOffset];
    }
}

#pragma mark - setter
- (void)setSeletedIndex:(NSInteger)seletedIndex
{
    _seletedIndex = seletedIndex;
    
    [self.scrollview setContentOffset:CGPointMake(seletedIndex * self.view.frame.size.width, 0) animated:false];
}

#pragma mark - getter
- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        UIScrollView *scrollVw = [[UIScrollView alloc] init];
        scrollVw.delegate = self;
        scrollVw.showsVerticalScrollIndicator = false;
        scrollVw.showsHorizontalScrollIndicator = false;
        scrollVw.pagingEnabled = true;
        scrollVw.bounces = false;
        [self.view addSubview:scrollVw];
        _scrollview = scrollVw;
    }
    return _scrollview;
}

- (NSMutableDictionary *)displayVcs
{
    if (!_displayVcs) {
        _displayVcs = [[NSMutableDictionary alloc] init];
    }
    return _displayVcs;
}

- (NSMutableDictionary *)memoryCache
{
    if (!_memoryCache) {
        _memoryCache = [[NSMutableDictionary alloc] init];
    }
    return _memoryCache;
}
@end
