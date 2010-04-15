// 「レシピ067:拡大縮小可能な画像ビューア」のサンプルコード (P.153)

#import <UIKit/UIKit.h>
@interface ZoomImageView : UIScrollView <UIScrollViewDelegate> {
    UIImageView *_imageView;
}
-(void)setImage:(UIImage*)image;
@end

@implementation ZoomImageView
// ピンチイン・ピンチアウトを動かすためのデリゲートメソッド
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void)setImage:(UIImage*)image {
    CGSize srcSize = image.size;
    CGSize boundsSize = self.bounds.size;
    self.zoomScale = 1.0;
    self.contentSize =srcSize;
    _imageView.image = image;


    self.minimumZoomScale = 1.0;
    // 最大サイズの計算
    // 最大サイズは、画像のオリジナルサイズだが、画像が小さいときは３倍
    CGFloat imageAspectRate = image.size.width/image.size.height; //画像の縦横の比率
    CGFloat viewAspectRate = boundsSize.width/boundsSize.height; //Viewの縦横の比率
    if (imageAspectRate > viewAspectRate) {
        self.maximumZoomScale = srcSize.width /boundsSize.width;
    }else{
        self.maximumZoomScale = srcSize.height /boundsSize.height;
    }
    if ((srcSize.width < boundsSize.width *3 )&&
        (srcSize.height < boundsSize.height *3 )) {
        self.maximumZoomScale = 3.0;
    }
    self.zoomScale = self.minimumZoomScale;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if( [touch tapCount]>1 )
    {
        if (self.zoomScale == self.maximumZoomScale) {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }else {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[[UIImageView alloc]init]retain];
        _imageView.frame = self.bounds;
        _imageView.autoresizesSubviews = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;

        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}
@end