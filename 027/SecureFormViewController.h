// 「レシピ027: 安全にパスワードを保存する」のサンプルコード (P.57)

#import <UIKit/UIKit.h>
#define SERVICE_NAME  @"Secure Form App"
#define PASSWORD_KEY  @"MyForm"

@interface SecureFormViewController : UIViewController <UITextFieldDelegate> {
}

+ (NSString *) getPassword;

- (void) savePassword;
- (void) clearPassword;

@end

