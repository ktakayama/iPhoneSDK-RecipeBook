// 「レシピ043: アラート内にUITextViewを表示する」のサンプルコード (P.90)

#import "TextAlertView.h"

@implementation TextAlertView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rect = CGRectMake(10.0f, 80.0f, 200.0f, 30.0f);
        textField = [[UITextField alloc] initWithFrame:rect];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"Name";
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:textField];
    }

    return self;
}

- (void)setFrame:(CGRect)rect {
    [super setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height+20)];
    self.center = CGPointMake(160, 150);
}

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        if ([[[view class] description] isEqualToString:@"UIThreePartButton"])
        {
            view.frame = CGRectMake(view.frame.origin.x,
                         self.bounds.size.height-view.frame.size.height-15,
                         view.frame.size.width,
                         view.frame.size.height);
        }
    }
}

@end