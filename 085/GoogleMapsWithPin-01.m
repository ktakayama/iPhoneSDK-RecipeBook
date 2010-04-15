// 「レシピ085: GoogleMapsにピンを立てる」のサンプルコード (P.202)

#import <MapKit/MapKit.h>

@interface SomeViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}
@end

@implementation SomeViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void) addPin {
   MyAnnotation *ano = [[MyAnnotation alloc]
      initWithCoordinate:[mapView centerCoordinate] title:@"Input Title"];
   [mapView addAnnotation:ano];
   [ano release];
}

- (MKAnnotationView *) mapView:(MKMapView *)aMapView
    viewForAnnotation:(id<MKAnnotation>)annotation {

    // 自前のアノテーションじゃない場合は何もせず
    if(![annotation isKindOfClass:[MyAnnotation class]])
        return [aMapView viewForAnnotation:aMapView.userLocation];

    // UITableViewCellと同じように、オブジェクトの再利用を行なう
    static NSString *identifier = @"pinAnnotation";
    MKPinAnnotationView *annView =
        (MKPinAnnotationView *)[aMapView
        dequeueReusableAnnotationViewWithIdentifier:identifier];

    if(!annView) {
        annView = [[[MKPinAnnotationView alloc]
            initWithAnnotation:annotation
            reuseIdentifier:identifier] autorelease];
    }

    annView.animatesDrop = YES;   // アニメーションを有効にする
    annView.canShowCallout = YES; // titleによる吹き出しを表示する
    // カスタム画像を使う場合
    // annView.image = [UIImage imageNamed:@"something.png"];

    return annView;
}

@end

