// 「レシピ112 :GoogleCalendarから予定を取得する」のサンプルコード (P.306)

#import "GDataCalendar.h"

@interface GCalendarSample : NSObject {
    GDataServiceGoogleCalendar *service;
}
@end
@implementation GCalendarSample
- (void)eventsTicket:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedCalendar *)feed
         error:(NSError *)error {

    if (error) {
        NSLog(@"fetch error: %@", error);
    } else if ([[feed entries] count] == 0) {
        NSLog(@"the user has no calendars");
    }else {
        for (GDataEntryCalendarEvent *event in [feed entries]) {
            GDataTextConstruct *titleTextConstruct = [event title];
            NSString *title = [titleTextConstruct stringValue];
            NSLog(@"event's title: %@", title);
            NSLog(@"event's content: %@",[[event content] stringValue]);

            NSArray *times = [event times];
            GDataWhen *when = nil;
            if ([times count] > 0) {
                when = [times objectAtIndex:0];
                NSLog(@"startTime :%@",[[when startTime] stringValue]);
                NSLog(@"endTime :%@",[[when endTime] stringValue]);
            }
            NSArray *reminders = [when reminders];
            if ([reminders count] > 0) {
                GDataReminder *reminder = [reminders objectAtIndex:0];
                NSLog(@"reminders :%d", [[reminder minutes] intValue] );
            }
            NSLog(@"ETag :%@ ",[event ETag]);
            if ([event postLink])
                NSLog(@"post link :%@ ",[[event postLink] URL]);
            if ([event editLink])
                NSLog(@"edit link :%@ ",[[event editLink] URL]);
            if ([event editMediaLink])
                NSLog(@"edit media link :%@ ",[[event editMediaLink] URL]);

            GDataLink *link = [event alternateLink];
            if (link != nil) {
                NSLog(@"url: %@", [link URL]);
            }
            GDataGeo *location = [event geoLocation];
            if (location) {

                double latitude = [location latitude];
                double longitude = [location longitude];

                NSString *titleParam =
                [GDataUtilities stringByURLEncodingStringParameter:title];

                NSString *template =
                @"http://maps.google.com/maps?q=%f,+%f+(%@)";
                NSString *urlStr = [NSString stringWithFormat:template,
                                    latitude, longitude, titleParam];
                NSLog(@" googleMap: %@",urlStr);
            }

        }
    }
}

- (void)ticket:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedCalendar *)feed
         error:(NSError *)error {

    if (error) {
        NSLog(@"fetch error: %@", error);
    } else if ([[feed entries] count] == 0) {
        NSLog(@"the user has no calendars");
    }else {
        for (GDataEntryCalendar *calendar in [feed entries]) {
            GDataTextConstruct *titleTextConstruct = [calendar title];
            NSString *title = [titleTextConstruct stringValue];
            NSLog(@"calendar's title: %@", title);
            NSLog(@"color :%@ ",[[calendar color] stringValue]);
            NSLog(@"hidden :%d ",[calendar isHidden]);
            NSLog(@"ETag :%@ ",[calendar ETag]);
            NSLog(@"post link :%@ ",[[calendar postLink] URL]);
            NSLog(@"edit link :%@ ",[[calendar editLink] URL]);
            NSLog(@"edit media link :%@ ",[[calendar editMediaLink] URL]);

            GDataLink *link = [calendar alternateLink];

            if (link != nil) {
                NSLog(@"url: %@", [link URL]);
                [service fetchFeedWithURL:[link URL]
                    delegate:self didFinishSelector:
                    @selector(eventsTicket:finishedWithFeed:error:)];
            }
            NSLog(@"=====================");
        }
    }
}

- (void) getCalendar {
    NSString *username=@"******"; //ユーザ名を設定
    NSString *password=@"******"; //パスワードを設定

    service =
    [[GDataServiceGoogleCalendar alloc] init];


    [service setUserCredentialsWithUsername:username
                                   password:password];

    // for performance
    //http://code.google.com/p/gdata-objectivec-client/wiki/PerformanceTuning
    [service setServiceShouldFollowNextLinks:YES];
    //[query setMaxResults:1000];
    [service setShouldCacheDatedData:YES];
    // for performance for iPhone
    [service setShouldServiceFeedsIgnoreUnknowns:YES];

    NSURL *feedURL = [GDataServiceGoogleCalendar
                      calendarFeedURLForUsername:username];

    GDataServiceTicket *ticket;
    ticket = [service fetchFeedWithURL:feedURL
                delegate:self
                didFinishSelector:
                @selector(ticket:finishedWithFeed:error:)];
}
@end

