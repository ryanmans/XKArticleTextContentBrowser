//
//  XKArticleTextContentPagePdfViewController.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentPagePdfViewController.h"
#import "XKArticleTextContentPageBrowser.h"

@interface XKArticleTextContentPagePdfViewController ()<XKArticleTextContentPageBrowserDelegate>
@property(nonatomic,strong)XKArticleTextContentPageBrowser * pageBrowser;

@end

@implementation XKArticleTextContentPagePdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CoreGraphics绘制PDF文件";
    
    //基于QuickLook框架实现PDF文件预览
    self.pageBrowser = [[XKArticleTextContentPageBrowser alloc] initWithFrame:self.view.bounds];
    self.pageBrowser.delegate = self;
    [self.pageBrowser showTrainArticleBrowserIn:self];
    
    [self.pageBrowser reloadDatas:@"http://public.cdn.sinoxk.com/support/opencourse/KP4Zqwr1RLNT.pdf"];
}

//MARK:XKTrainArticleContentBrowserDelegate
- (void)articleTextContentBrowser:(XKArticleTextContentPageBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.view.transform = CGAffineTransformIdentity;
        self.pageBrowser.frame = self.view.bounds;
    }];
}
@end
