// 「レシピ028: 起動パスワードを付ける」のサンプルコード (P.61)

#import <UIKit/UIKit.h>
#import "SecureFormViewController.h"

@interface PasswordCheckViewController :
                UIViewController <UITextFieldDelegate> {
    SecureFormViewController *controller;
}

@end

