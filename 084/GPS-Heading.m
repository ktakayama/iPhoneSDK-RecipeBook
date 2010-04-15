// 「レシピ084: 方位を取得する」のサンプルコード (P.199)

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface SomeClass : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

- (void) stopUpdatingHeading;

@end

@implementation SomeClass

- (id) init {
    if(self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        // 電子コンパスが利用可能かチェック
        if([locationManager headingAvailable]) {
            locationManager.delegate = self;
            [locationManager startUpdatingHeading];
        }
    }
    return self;
}

- (void) locationManager:(CLLocationManager *)manager
         didUpdateHeading:(CLHeading *)newHeading {
    // 方位の情報が更新される度に呼ばれます

    // 方位(0だと北で、180だと南を指します)
    CLLocationDirection trueHeading = newHeading.trueHeading;     // 真北
    CLLocationDirection magHeading  = newHeading.magneticHeading; // 磁北
    CLLocationDirection accuHeading = newHeading.headingAccuracy; // 精度

    // XYZ軸の地磁気データ(マイクロテスラ単位)
    CLHeadingComponentValue x = newHeading.x;
    CLHeadingComponentValue y = newHeading.y;
    CLHeadingComponentValue z = newHeading.z;

    NSLog(@"%f %f %f", trueHeading, magHeading, accuHeading);
    NSLog(@"%f %f %f", x, y, z);
}

- (void) stopUpdatingHeading {
    // 情報の更新を停止する
    [locationManager stopUpdatingHeading];
}

- (void) dealloc {
    [locationManager release];
    [super dealloc];
}

@end

