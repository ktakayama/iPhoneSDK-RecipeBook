// 「レシピ089: メールを送信する」のサンプルコード (P.213)

#import "SampleMailViewController.h"

#define MAIL_SUBJECT @"メール件名"
#define MAIL_BODY    @"メール本文"
#define MAIL_TO   [NSArray arrayWithObject:@"to@example.com"]
#define MAIL_CC   [NSArray arrayWithObject:@"cc@example.com"]
#define MAIL_BCC  [NSArray arrayWithObjects:@"bcc@example.com", @"bcc2@example.com", nil]

@implementation SampleMailViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 200, 120, 30)];
    [btn setTitle:@"Launch Mail" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launchMailComposer)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void) launchMailComposer {
    Class klass = NSClassFromString(@"MFMailComposeViewController");
    if(klass != nil) {
        if([klass canSendMail]) {
            [self openMailComposer];
        } else {
            [self openMailApp];
        }
    } else {
        [self openMailApp];
    }
}

- (void) openMailComposer {
    // メールコンポーザーを起動する場合
    MFMailComposeViewController *picker =
                    [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;

    // ヘッダの指定
    [picker setSubject:MAIL_SUBJECT];
    [picker setToRecipients:MAIL_TO];
    [picker setCcRecipients:MAIL_CC];
    [picker setBccRecipients:MAIL_BCC];
    [picker setMessageBody:MAIL_BODY isHTML:NO];

    // ファイルの添付
    NSString *path = [[NSBundle mainBundle]
                        pathForResource:@"sample" ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData
                mimeType:@"image/png" fileName:@"sample photo"];

    // 起動
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) openMailApp {
    // メールアプリに切り替えの場合
    NSString *query =
     [NSString stringWithFormat:@"mailto:%@?cc=%@&bcc=%@&subject=%@&body=%@",
     [MAIL_TO componentsJoinedByString:@","],
     [MAIL_CC componentsJoinedByString:@","],
     [MAIL_BCC componentsJoinedByString:@","], MAIL_SUBJECT, MAIL_BODY];
    NSString *q =
     [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:q]];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller
    didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
   // resultに、メール送信の結果が入る
   [self dismissModalViewControllerAnimated:YES];
}

@end

