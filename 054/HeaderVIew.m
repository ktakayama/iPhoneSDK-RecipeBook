// 「レシピ054: UITableViewをプルダウンしたことを感知する」のサンプルコード (P.126)

#import "HeaderView.h"

@implementation HeaderView

@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        label = [[UILabel alloc]
          initWithFrame:CGRectMake(0.0f,frame.size.height-30.0f,320.0f,20.0f)];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"Pull Down Reload";
        [self addSubview:label];
    }
    return self;
}

- (void)dealloc {
    [label release];
    [super dealloc];
}

@end