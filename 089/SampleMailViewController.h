// 「レシピ089: メールを送信する」のサンプルコード (P.212)

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SampleMailViewController :
                UIViewController <MFMailComposeViewControllerDelegate> {
}

- (void) launchMailComposer;
- (void) openMailComposer;
- (void) openMailApp;

@end

