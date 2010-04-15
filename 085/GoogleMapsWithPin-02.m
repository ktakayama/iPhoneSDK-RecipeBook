// 「レシピ085: GoogleMapsにピンを立てる」のサンプルコード (P.202)

- (void) addPin {
    MyAnnotation *ano = [[MyAnnotation alloc]
        initWithCoordinate:[mapView centerCoordinate] title:@"Input Title"];
    [mapView addAnnotation:ano];
    [ano release];
}

