//
//  XKArticleTextContentWebBrowser.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKArticleTextContentWebKitBrowser;
@protocol XKArticleTextContentWebKitBrowserDelegate <NSObject>
@optional
//加载
- (void)articleTextContentWebKitBrowser:(XKArticleTextContentWebKitBrowser *)articleBrowser didFinishLoadDataWithError:(BOOL)error;

//展现方向 orientation: 1-竖屏,2-横屏
- (void)articleTextContentWebKitBrowser:(XKArticleTextContentWebKitBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation;

//滚动到底部
- (void)articleContentWebKitBrowserDidScrollToBottom:(XKArticleTextContentWebKitBrowser *)articleBrowser;
@end


@interface XKArticleTextContentWebKitBrowser : UIView

@property (nonatomic, weak) id<XKArticleTextContentWebKitBrowserDelegate> delegate;

//加载到控制器上
- (void)showTrainArticleBrowserIn:(UIViewController*)viewController;

//加载数据
- (void)reloadDatas:(NSString*)fileUrl;

@end

NS_ASSUME_NONNULL_END
