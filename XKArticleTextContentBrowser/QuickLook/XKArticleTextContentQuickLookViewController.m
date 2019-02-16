//
//  XKArticleTextContentQuickLookViewController.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentQuickLookViewController.h"
#import "XKArticleTextContentQuickLookBrowser.h"

@interface XKArticleTextContentQuickLookViewController ()<XKArticleTextContentQuickLookBrowserDelegate>
@property(nonatomic,strong)XKArticleTextContentQuickLookBrowser * quickLookBrowser;
@end

@implementation XKArticleTextContentQuickLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QuickLook框架预览PDF";

    //基于QuickLook框架实现PDF文件预览
    self.quickLookBrowser = [[XKArticleTextContentQuickLookBrowser alloc] initWithFrame:self.view.bounds];
    self.quickLookBrowser.delegate = self;
    [self.quickLookBrowser showTrainArticleBrowserIn:self];
    
    [self.quickLookBrowser reloadDatas:@"http://public.cdn.sinoxk.com/support/opencourse/KP4Zqwr1RLNT.pdf"];
}

//MARK:XKTrainArticleContentBrowserDelegate
- (void)articleTextContentBrowser:(XKArticleTextContentQuickLookBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.view.transform = CGAffineTransformIdentity;
        self.quickLookBrowser.frame = self.view.bounds;
    }];
}
@end
