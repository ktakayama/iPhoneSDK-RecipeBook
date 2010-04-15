// 「レシピ113 :GoogleCalendarに予定を追加する」のサンプルコード (P.310)

#import "GDataCalendar.h"

@interface GCalendarAddSample : NSObject {
    GDataServiceGoogleCalendar *service;
    NSURL *postURL;

}
@end
@implementation GCalendarAddSample

- (void)didAddSchedule:(GDataServiceTicket *)ticket
    addedEntry:(GDataEntryCalendarEvent *)event
               error:(NSError *)error {

    if (error) {
        NSLog(@"error: %@", error);
    }else {
        NSLog(@"added:%@",[[event title] stringValue]);
        NSLog(@" ETag:%@",[event ETag]);
    }
}

- (void)addAnEventToCalendar {
    GDataEntryCalendarEvent *newEvent =
        [GDataEntryCalendarEvent calendarEvent];

    // タイトルと説明
    [newEvent setTitleWithString:@"予定サンプル"];
    [newEvent setContentWithString:@"説明欄サンプル"];

    // 現在日時の２４時間後を予定開始日時とし、その１時間後を終了日時とする
    NSDate *aDayFromNow = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    NSDate *aDayAndHourFromNow =
        [NSDate dateWithTimeIntervalSinceNow:60*60*25];
    GDataDateTime *startDateTime =
        [GDataDateTime dateTimeWithDate:aDayFromNow
        timeZone:[NSTimeZone systemTimeZone]];
    GDataDateTime *endDateTime =
        [GDataDateTime dateTimeWithDate:aDayAndHourFromNow
        timeZone:[NSTimeZone systemTimeZone]];

    GDataWhen *when = [GDataWhen whenWithStartTime:startDateTime
                                           endTime:endDateTime];
    // リマインダを１０分前に設定
    GDataReminder *reminder = [GDataReminder reminder];
    [reminder setMinutes:@"10"];
    [when addReminder:reminder];

    [newEvent addTime:when];

    // サーバにポストする
    [service
        fetchEntryByInsertingEntry:newEvent
        forFeedURL:postURL
        delegate:self
        didFinishSelector:@selector(didAddSchedule:addedEntry:error:)];

}

-(void)setupService:(NSString*)username password:(NSString*)password {

    service = [[[GDataServiceGoogleCalendar alloc] init] autorelease];
    [service setUserCredentialsWithUsername:username
                                   password:password];

    // エージェントを設定(書式:yourName-appName-appVersion)
    [service setUserAgent:@"MyCompany-GSample-1.0"];

    // パフォーマンスを良くするため
    [service setShouldServiceFeedsIgnoreUnknowns:YES];

    // 以下のpostURLにすると、ユーザの所有するカレンダにGoogleが割り振ってくれる
    // 異なるカレンダを指定したい場合は、カレンダ情報のfeedを取得後、
    // alternativeURLを使うと良い
    NSString *postURLString =
        @"http://www.google.com/calendar/feeds/default/private/full";
    postURL = [NSURL URLWithString:postURLString];
}
@end
