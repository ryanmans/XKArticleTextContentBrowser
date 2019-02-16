//
//  XKArticleTextContentWebViewController.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentWebViewController.h"
#import "XKArticleTextContentWebKitBrowser.h"

@interface XKArticleTextContentWebViewController ()<XKArticleTextContentWebKitBrowserDelegate>
@property(nonatomic,strong)XKArticleTextContentWebKitBrowser * webBrowser;

@end

@implementation XKArticleTextContentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"webkit框架预览PDF";
    
    //基于webkit框架实现PDF文件预览
    self.webBrowser = [[XKArticleTextContentWebKitBrowser alloc] initWithFrame:self.view.bounds];
    self.webBrowser.delegate = self;
    [self.webBrowser showTrainArticleBrowserIn:self];
    
    [self.webBrowser reloadDatas:@"http://public.cdn.sinoxk.com/support/opencourse/KP4Zqwr1RLNT.pdf"];
}

- (void)articleTextContentBrowser:(XKArticleTextContentWebKitBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.view.transform = CGAffineTransformIdentity;
        self.webBrowser.frame = self.view.bounds;
    }];
}


@end
