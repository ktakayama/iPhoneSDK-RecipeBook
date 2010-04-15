// 「レシピ078:PDFを生成する」のサンプルコード (P.188)

#import <UIKit/UIKit.h>
@interface PDFCreate 
{
}
@end
@implementation PDFCreate
+(void) MyCreatePDFFile:(NSString*)path
{
    // ファイル情報の作成
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"PDF Title" forKey:(NSString*)kCGPDFContextTitle];
    [dic setObject:@"Creator Name" forKey:(NSString*)kCGPDFContextCreator];

    // コンテキストとファイルの生成
    // 領域をA4サイズ:595.44px,841.68px(8.27インチ,11.69インチ,72dpi)に指定
    // NULL指定の場合letterサイズ:612px,792px(8.5インチ,11インチ,72dpi)となる
    CGRect pageRect = CGRectMake(0, 0, 595.44, 841.68);
    NSURL *url = [NSURL fileURLWithPath:path];
    CGContextRef context = CGPDFContextCreateWithURL((CFURLRef)url,
        &pageRect, (CFMutableDictionaryRef)dic);

    // 1ページ目開始
    CGPDFContextBeginPage(context,(CFMutableDictionaryRef)dic);
    UIGraphicsPushContext(context);

    //上下反転の対処
    CGContextTranslateCTM(context, 0, pageRect.size.height);
    CGContextScaleCTM(context, 1, -1);

    // テキストを描画
    NSString *title=@"PDF Documentを作る";
    [title drawAtPoint:CGPointMake(10, 10)
        withFont:[UIFont systemFontOfSize:18]];

    // 1ページ目終了
    UIGraphicsPopContext();
    CGPDFContextEndPage (context);

    // 2ページ目開始
    CGPDFContextBeginPage(context,(CFMutableDictionaryRef)dic);
    UIGraphicsPushContext(context);

    //上下反転の対処
    CGContextTranslateCTM(context, 0, pageRect.size.height);
    CGContextScaleCTM(context, 1, -1);

    //図形の描画
    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
    CGContextFillRect(context,CGRectMake(10,30,100,100));

    //イメージの描画
    UIImage *i = [UIImage imageNamed:@"Balloon.png"];
    [i drawAtPoint:CGPointMake(100, 200)];
    [i release];

    // 2ページ目終了
    UIGraphicsPopContext();
    CGPDFContextEndPage (context);

    CGContextRelease (context);
    [dic release];
}
@end