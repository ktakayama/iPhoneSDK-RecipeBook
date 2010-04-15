// 「レシピ083: 現在位置を取得する」のサンプルコード (P.197)

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface SomeClass : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

- (void) stopUpdatingLocation;

@end

@implementation SomeClass

- (id) init {
    if(self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        // GPSが利用可能かチェック
        if([locationManager locationServicesEnabled]) {
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
        }
    }
    return self;
}

- (void) locationManager:(CLLocationManager*)manager
        didUpdateToLocation:(CLLocation*)newLocation
                fromLocation:(CLLocation*)oldLocation {
    // 位置情報が更新される度に呼ばれます
    // newLocationに現在地のデータが、
    // oldLocationに前回計測時のデータが入ります
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CLLocationDegrees latitude  = coordinate.latitude;  // 緯度
    CLLocationDegrees longitude = coordinate.longitude; // 経度

    NSLog(@"%f,%f", latitude, longitude);
}

- (void) locationManager:(CLLocationManager *)manager
            didFailWithError:(NSError *)error {
    // 位置情報の取得に失敗すると呼ばれる
    NSLog(@"error: %@", [error localizedDescription]);

    if([error code] == kCLErrorDenied) {
        // 位置情報の取得を「許可しない」を選択した場合に呼ばれる
    }
}

- (void) stopUpdatingLocation {
    // 位置情報の更新を停止する
    [locationManager stopUpdatingLocation];
}

- (void) dealloc {
    [locationManager release];
    [super dealloc];
}

@end

