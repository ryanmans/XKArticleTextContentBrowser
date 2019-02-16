//
//  XKArticleTextContentPageBrowser.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKArticleTextContentPageBrowser;
@protocol XKArticleTextContentPageBrowserDelegate <NSObject>
@optional
//加载
- (void)articleTextContentBrowser:(XKArticleTextContentPageBrowser *)pageBrowser didFinishLoadData:(BOOL)error;

//展现方向 orientation: 1-竖屏,2-横屏
- (void)articleTextContentBrowser:(XKArticleTextContentPageBrowser *)pageBrowser didDisplayOrientation:(NSUInteger)orientation;

//滚动视图回调
- (void)articleTextContentBrowser:(XKArticleTextContentPageBrowser *)pageBrowser scrollToContentViewAtIndex:(NSInteger)index scrollCompleted:(BOOL)completed;

@end


@interface XKArticleTextContentPageBrowser : UIView
@property (nonatomic, weak) id<XKArticleTextContentPageBrowserDelegate> delegate;

//加载到控制器上
- (void)showTrainArticleBrowserIn:(UIViewController*)viewController;

//加载数据
- (void)reloadDatas:(NSString*)fileUrl;
@end

NS_ASSUME_NONNULL_END
