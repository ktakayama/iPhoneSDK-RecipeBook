// 「レシピ021: NSArrayをランダムに並び替える」のサンプルコード (P.43)

@interface NSArray (randomized)
- (NSArray *) randomizedArray;
@end

@implementation NSArray (randomized)
- (NSArray *) randomizedArray {
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];

    int i = [results count];
    while(--i > 0) {
        int j = rand() % (i+1);
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
    }

    return [NSArray arrayWithArray:results];
}
@end

