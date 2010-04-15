// 「レシピ039:絵文字を描画する」のサンプルコード (P.81)
#import <UIKit/UIKit.h>
@interface EmojiView : UIScrollView {
    NSMutableArray *emojiIds;
}
@end
@implementation EmojiView

-(CGFloat)drawEmojisStart:(unsigned int)start
                      end:(unsigned int)end x:(CGFloat)x {
    int heightCount = 20;
    UITextView *tv;
    NSMutableString *t ;
    for (int i=0 ; i< end-start+1; i++)
    {
        if (i % heightCount ==0) {
            tv= [[UITextView alloc]initWithFrame:CGRectMake(x,0,90,460)];
            tv.font = [UIFont systemFontOfSize:18];
            tv.userInteractionEnabled = NO;
            [self addSubview:tv];
            t = [[NSMutableString alloc] init];
            x += 90;
        }
        NSString *iconString =
            [NSString stringWithFormat:@"%C:%X ",start+i,start+i ];
        [t appendString:iconString];
        tv.text = t;
    }
    return x;
}

-(id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setContentSize:CGSizeMake(2620, 460)];

        CGFloat x = 0;
        x = [self drawEmojisStart:0xE001 end:0xE05A x:x];
        x = [self drawEmojisStart:0xE101 end:0xE15A x:x];
        x = [self drawEmojisStart:0xE201 end:0xE253 x:x];
        x = [self drawEmojisStart:0xE301 end:0xE34D x:x];
        x = [self drawEmojisStart:0xE401 end:0xE44C x:x];
        x = [self drawEmojisStart:0xE501 end:0xE537 x:x];
    }
    return self;
}
@end
