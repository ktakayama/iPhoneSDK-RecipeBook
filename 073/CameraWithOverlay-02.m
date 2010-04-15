// 「レシピ073: カメラの映像にViewを重ねる」のサンプルコード (P.176)

UIImagePickerController *cameraController =
                [[UIImagePickerController alloc] init];
cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
cameraController.delegate = self;
// ボタン類を隠す
cameraController.showsCameraControls = NO;

// オーバレイを作成
UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
btn.frame = CGRectMake(135, 437, 50, 30);
[btn setTitle:@"撮影" forState:UIControlStateNormal];
[btn addTarget:cameraController action:@selector(takePicture)
                           forControlEvents:UIControlEventTouchDown];
cameraController.cameraOverlayView = btn;

[self presentModalViewController:cameraController animated:YES];
[cameraController release];

