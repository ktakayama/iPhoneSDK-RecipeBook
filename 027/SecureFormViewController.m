// 「レシピ027: 安全にパスワードを保存する」のサンプルコード (P.58)

#import "SecureFormViewController.h"
#import "SFHFKeychainUtils.h"

#define FIELD_TAG 1

@implementation SecureFormViewController

+ (NSString *) getPassword {
    NSError *error;
    return [SFHFKeychainUtils getPasswordForUsername:PASSWORD_KEY
                            andServiceName:SERVICE_NAME error:&error];
}

- (void) loadView {
    [super loadView];

    UITextField *field;
    UIButton *btn;
    NSString *savedPassword;

    // 保存されているパスワードの読み込み
    savedPassword = [SecureFormViewController getPassword];
    NSLog(@"Saved Password: %@", savedPassword);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,60,240,20)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"パスワードを設定します";
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];

    // インプットフィールド
    field = [[UITextField alloc] initWithFrame:CGRectMake(60, 100, 200, 30)];
    field.tag = FIELD_TAG;
    field.text = savedPassword;
    field.delegate = self;
    field.secureTextEntry = YES;
    field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:field];
    [field becomeFirstResponder];
    [field release];

    // 保存ボタン
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(80,150,60,30);
    [btn setTitle:@"Save" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(savePassword)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    // クリアボタン
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(180,150,60,30);
    [btn setTitle:@"Clear" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearPassword)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void) savePassword {
    // パスワードの保存
    UITextField *field = (UITextField *)[self.view viewWithTag:FIELD_TAG];
    NSError *error;
    [SFHFKeychainUtils storeUsername:PASSWORD_KEY andPassword:field.text
        forServiceName:SERVICE_NAME updateExisting:YES error:&error];
}

- (void) clearPassword {
    // パスワードの削除
    UITextField *field = (UITextField *)[self.view viewWithTag:FIELD_TAG];
    field.text = @"";
    NSError *error;
    [SFHFKeychainUtils deleteItemForUsername:PASSWORD_KEY
        andServiceName:SERVICE_NAME error:&error];
}

- (void) dealloc {
    [super dealloc];
}
@end

