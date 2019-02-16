//
//  XKArticleTextContentBrowserDelegate.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XKArticleTextContentBrowserDelegate <NSObject>

- (void)articleTextContentBrowser:(UIView*)articleBrowser didFinishLoadDataWithError:(BOOL)error;

//展现方向 orientation: 1-竖屏,2-横屏
- (void)articleTextContentBrowser:(UIView *)articleBrowser didDisplayOrientation:(NSUInteger)orientation;

@end

NS_ASSUME_NONNULL_END
