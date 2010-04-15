// 「レシピ073: カメラの映像にViewを重ねる」のサンプルコード (P.176)

UIImagePickerController *cameraController =
                [[UIImagePickerController alloc] init];
cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
cameraController.delegate = self;

// オーバレイを作成
SomeView *view = [[SomeView alloc] initWithFrame:CGRectMake(0,0,320,427)];
cameraController.cameraOverlayView = view;
[view release];

[self presentModalViewController:cameraController animated:YES];
[cameraController release];

