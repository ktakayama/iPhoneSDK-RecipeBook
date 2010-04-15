// 「レシピ050: カスタムセルを利用する」のサンプルコード (P.116)

@interface MyCustomCell : UITableViewCell {
    UILabel *mainText;
    UILabel *description;
}

@property (nonatomic, assign) UILabel *mainText;
@property (nonatomic, assign) UILabel *description;

@end

@implementation MyCustomCell

@synthesize mainText, description;

- (id) initWithStyle:(UITableViewCellStyle)style
        reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        mainText = [[UILabel alloc]
                        initWithFrame:CGRectMake(10, 15, 100, 25)];
        [self addSubview:mainText];
        [mainText release];

        description = [[UILabel alloc]
                            initWithFrame:CGRectMake(200, 15, 100, 25)];
        [self addSubview:description];
        [description release];
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(self.selected) {
       mainText.textColor = [UIColor whiteColor];
       description.textColor = [UIColor whiteColor];
    } else {
       mainText.textColor = [UIColor blackColor];
       description.textColor = [UIColor blueColor];
    }
}

- (void) dealloc {
    [super dealloc];
}

@end

