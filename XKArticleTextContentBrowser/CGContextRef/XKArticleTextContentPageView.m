//
//  XKArticleTextContentPageView.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentPageView.h"

@implementation XKArticleTextContentPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//绘制内容
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //调整坐标系
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);//先垂直下移height高度
    CGContextScaleCTM(context, 1.0, -1.0);//再垂直向上翻转
    //绘制pdf内容
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(self.pdfDocumentRef, self.page);
    CGContextSaveGState(context);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pageRef, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, pageRef);
    CGContextRestoreGState(context);
}
@end
