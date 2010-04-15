// 「レシピ041: UIPickerViewでエンドレスなロールを作る」のサンプルコード (P.86)

@implementation EndlessPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    strings = [[NSArray arrayWithObjects:
               @"Zero", @"One", @"Two", @"Three", @"Four", @"Five",
               @"Six", @"Seven", @"Eight", @"Nine", nil] retain];
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, 300, 120)];
    myPickerView.delegate = self;
    [self.view addSubview:myPickerView];
    [myPickerView release];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component {
    return [strings objectAtIndex:(row%10)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component {
    [self pickerViewLoaded:nil];
}

- (NSUInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSUInteger)component {
    return MAX_ROLL;
}

-(void)pickerViewLoaded: (id)blah {
    NSUInteger max = MAX_ROLL;
    NSUInteger base10 = (max/2)-(max/2)%10;
    [myPickerView
       selectRow:[myPickerView selectedRowInComponent:0]%10+base10
       inComponent:0 animated:false];
}

- (NSUInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)dealloc {
    [strings release];
    [super dealloc];
}

@end