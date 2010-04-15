// 「レシピ040: UIButtonにひとつの画像で様々な大きさの背景画像を貼付ける」のサンプルコード (P.83)

// ノーマル状態のボタン背景
UIImage *normalImage = [UIImage imageNamed:@"button.png"];
UIImage *stretchImage = [normalImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
[button setBackgroundImage:stretchImage forState:UIControlStateNormal];

// ハイライト状態のボタン背景
UIImage *pushImage = [UIImage imageNamed:@"button2.png"];
UIImage *stretchImage2 = [pushImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
[button setBackgroundImage:stretchImage2 forState:UIControlStateHighlighted];