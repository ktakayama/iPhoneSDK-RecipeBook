// 「レシピ085: GoogleMapsにピンを立てる」のサンプルコード (P.201)

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
            title:(NSString *)aTitle;

@end

@implementation MyAnnotation

@synthesize coordinate, title;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
            title:(NSString *)aTitle {
    self = [super init];
    if (self != nil) {
        coordinate = coord;
        title = [aTitle retain];
    }
    return self;
}

- (void)dealloc {
    [title release];
    [super dealloc];
}

@end

