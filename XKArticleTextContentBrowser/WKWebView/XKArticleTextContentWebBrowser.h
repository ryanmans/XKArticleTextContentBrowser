//
//  XKArticleTextContentWebBrowser.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKArticleTextContentWebBrowser;
@protocol XKArticleTextContentWebBrowserDelegate <NSObject>
@optional
//加载
- (void)articleTextContentBrowser:(XKArticleTextContentWebBrowser *)articleBrowser didFinishLoadData:(BOOL)error;

//展现方向 orientation: 1-竖屏,2-横屏
- (void)articleTextContentBrowser:(XKArticleTextContentWebBrowser *)articleBrowser didDisplayOrientation:(NSUInteger)orientation;

@end


@interface XKArticleTextContentWebBrowser : UIView

@property (nonatomic, weak) id<XKArticleTextContentWebBrowserDelegate> delegate;

//加载到控制器上
- (void)showTrainArticleBrowserIn:(UIViewController*)viewController;

//加载数据
- (void)reloadDatas:(NSString*)fileUrl;

@end

NS_ASSUME_NONNULL_END
