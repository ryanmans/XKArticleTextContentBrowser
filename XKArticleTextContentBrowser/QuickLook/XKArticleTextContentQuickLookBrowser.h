//
//  XKArticleTextContentQuickLookBrowser.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKArticleTextContentQuickLookBrowser;
@protocol XKArticleTextContentQuickLookBrowserDelegate <NSObject>
@optional
//加载
- (void)articleTextContentBrowser:(XKArticleTextContentQuickLookBrowser *)articleBrowser didFinishLoadData:(BOOL)error;

//展现方向 orientation: 1-竖屏,2-横屏
- (void)articleTextContentBrowser:(XKArticleTextContentQuickLookBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation;

@end

//基于QuickLook框架实现PDF文件预览
@interface XKArticleTextContentQuickLookBrowser : UIView

@property (nonatomic, weak) id<XKArticleTextContentQuickLookBrowserDelegate> delegate;

//加载到控制器上
- (void)showTrainArticleBrowserIn:(UIViewController*)viewController;

//加载数据
- (void)reloadDatas:(NSString*)fileUrl;

@end

NS_ASSUME_NONNULL_END
