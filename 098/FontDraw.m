// 「レシピ098: FontLabelライブラリで自由にフォントを使う」のサンプルコード (P.247)

#import "FontManager.h"
#import "FontLabelStringDrawing.h"

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];  // 文字色を指定

    NSString *str = @"サンプルテキストさんぷるてきすと";
    ZFont *font = [[FontManager sharedManager]
                    zFontWithName:@"ipam" pointSize:20];

    [str drawAtPoint:CGPointMake(0, 20) withZFont:font];

    [str drawAtPoint:CGPointMake(0, 50) forWidth:140.0f
            withZFont:font lineBreakMode:UILineBreakModeTailTruncation];

    [str drawInRect:CGRectMake(0, 80, 140, 20) withZFont:font];

    [str drawInRect:CGRectMake(0, 110, 140, 60)
        withZFont:font lineBreakMode:UILineBreakModeTailTruncation];

    [str drawInRect:CGRectMake(0, 180, 140, 60)
        withZFont:font lineBreakMode:UILineBreakModeTailTruncation
        alignment:UITextAlignmentRight];

    [str drawInRect:CGRectMake(0, 250, 140, 60)
        withZFont:font lineBreakMode:UILineBreakModeTailTruncation
        alignment:UITextAlignmentRight numberOfLines:2];
}

