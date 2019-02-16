//
//  XKArticleTextContentPageViewController.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentPageViewController.h"
#import "XKArticleTextContentPageView.h"

@interface XKArticleTextContentPageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)XKArticleTextContentPageView * textContentView;
@end

@implementation XKArticleTextContentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1.0;
    [self.view addSubview:self.scrollView];
    
    self.textContentView = [[XKArticleTextContentPageView alloc] initWithFrame:self.view.bounds];
    self.textContentView.page = self.page;
    self.textContentView.pdfDocumentRef = self.pdfDocumentRef;
    [self.scrollView addSubview:self.textContentView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.onArticleTextContentPageNumBlock) self.onArticleTextContentPageNumBlock(self.page);
}

//重载
- (void)reloadDatas{
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.textContentView.frame = self.view.bounds;
    [self.textContentView setNeedsDisplay];
}

#pragma - mark UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.textContentView;
}
@end
