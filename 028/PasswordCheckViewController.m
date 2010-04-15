// 「レシピ028: 起動パスワードを付ける」のサンプルコード (P.61)

#import "PasswordCheckViewController.h"
#import "SFHFKeychainUtils.h"

@implementation PasswordCheckViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    if([SecureFormViewController getPassword] == nil) {
        controller = [[SecureFormViewController alloc] init];
        [self.view addSubview:controller.view];
        return;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,60,240,20)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"秘密のエリアです";
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];

    UITextField *field;
    field = [[UITextField alloc] initWithFrame:CGRectMake(60, 100, 200, 30)];
    field.delegate = self;
    field.secureTextEntry = YES;
    field.returnKeyType = UIReturnKeyDone;
    field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:field];
    [field becomeFirstResponder];
    [field release];
}

- (BOOL) textFieldShouldReturn:(UITextField *)field {
    NSString *password = [SecureFormViewController getPassword];
    if([field.text isEqualToString:password]) {
        // パスワードが正しい
        field.text = @"";
        [self.view removeFromSuperview];
    } else {
        // パスワードが間違っている
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                message:@"パスワードが間違っています" delegate:nil
                cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return 1;
}

- (void) dealloc {
    [controller release];
    [super dealloc];
}

@end

