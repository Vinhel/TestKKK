//
//  SegControl.m
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/10.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "SCSegmentControl.h"
#import "NSString+customString.h"

#define SegControlSpace (5)
#define SegControlAnimationTime (0.5)

@interface SegControlItem : UIView

@property (nonatomic, strong) UIImageView *titleIconView;
- (void)setSelected:(BOOL)selected;

@end

@implementation SegControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    CGRect segmentRect = self.bounds;
    _titleIconView = [[UIImageView alloc] initWithFrame:CGRectMake(segmentRect.origin.x, segmentRect.origin.y, segmentRect.size.width, segmentRect.size.height)];
    if (title) {
        [_titleIconView setImage:[UIImage imageNamed:title]];
    }else{
        [_titleIconView setImage:[UIImage imageNamed:@"logo"]];
    }
    [self addSubview:_titleIconView];
    }
      return self;
}

- (void)setSelected:(BOOL)selected
{
   
}

- (void)resetTitle:(NSString *)title
{
        CGRect frame = _titleIconView.frame;
        frame.origin.x = CGRectGetMaxX(_titleIconView.frame) + SegControlSpace;
        _titleIconView.frame = frame;
    
}


@end

@interface SCSegmentControl ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *contentView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items, *titleMutArr;

@property (nonatomic , weak) id <SegControlDelegate> delegate;

@property (nonatomic , copy) SegControlBlock block;

@property (nonatomic) NSArray *disableIndexArr;

@end

@implementation SCSegmentControl

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI_Ites:titleItem];
    }
    return self;
}

- (void)setupUI_Ites:(NSArray *)items
{
    _contentView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [scrollView addGestureRecognizer:tapGes];
        [tapGes requireGestureRecognizerToFail:scrollView.panGestureRecognizer];
        scrollView;
    });
    self.backgroundColor = [UIColor clearColor];
    
    [self initItemsWithTitleArray:items];
}

- (void)doTap:(UIGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
//    [self checkUserId:_checkType];
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        if ([weakSelf.disableIndexArr containsObject:[NSString stringWithFormat:@"%lu", (unsigned long)idx]]) {
            return;
        }
        
        if (CGRectContainsPoint(rect, point)) {
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];

}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SegControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray
{
    _itemFrames = @[].mutableCopy;
    _items = @[].mutableCopy;
    _titleMutArr = [NSMutableArray arrayWithArray:titleArray];
    float y = 0;
    float height = CGRectGetHeight(self.bounds);
   
    CGRect firstFrame = CGRectMake(0, 0, self.frame.size.width/_titleMutArr.count-1, height);
    [_itemFrames addObject:[NSValue valueWithCGRect:firstFrame]];
    
    for (int i = 1; i < titleArray.count; i++) {
        float x = CGRectGetMaxX([_itemFrames[i-1] CGRectValue])+1;
        CGRect rect = CGRectMake(x, y, firstFrame.size.width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
    }
    
    for (int i = 0; i < titleArray.count; i++) {
        CGRect rect = [_itemFrames[i] CGRectValue];
        SegControlItem *item;
        
        NSString *image = titleArray[i];
        item = [[SegControlItem alloc]initWithFrame:rect title:image
                ];
        if (item) {
            if (i == 0) {
                [item setSelected:YES];
            }
            [_items addObject:item];
            [_contentView addSubview:item];
        }
    }
    
    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = 0;
    [self selectIndex:0];
 }

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    SegControlItem *curItem = [_items objectAtIndex:index];
    [curItem resetTitle:title];
}


- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem selectedBlock:(SegControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)selectIndex:(NSInteger)index
{
    //    [self addRedLine];
    if (index < 0) {
        _currentIndex = -1;
        for (SegControlItem *curItem in _items) {
            [curItem setSelected:NO];
        }
    } else {
        if (!_currentIndex) {
            SegControlItem *curItem = [_items objectAtIndex:index];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:SegControlAnimationTime animations:^{
                
            } completion:^(BOOL finished) {
                [_items enumerateObjectsUsingBlock:^(SegControlItem *item, NSUInteger idx, BOOL *stop) {
                    [item setSelected:NO];
                    NSString *imgName;
                    
                    if (index == idx) {
                        NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                        imgName = [name replace:@"off" withString:@"on"];
                        
                    }else if(weakSelf.currentIndex == idx) {
                        NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                        imgName = [name replace:@"on" withString:@"off"];
                    }
                    if (imgName) {
                        [item.titleIconView setImage: [UIImage imageNamed:imgName]];
                    }
                    
                }];
                [curItem setSelected:YES];
                _currentIndex = index;
            }];
            
        }
        
        else   if (index != _currentIndex ) {
            SegControlItem *curItem = [_items objectAtIndex:index];
            if (_currentIndex < 0) {
                [curItem setSelected:YES];
                _currentIndex = index;
            } else {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:SegControlAnimationTime animations:^{
                    
                } completion:^(BOOL finished) {
                    [_items enumerateObjectsUsingBlock:^(SegControlItem *item, NSUInteger idx, BOOL *stop) {
                        [item setSelected:NO];
                        NSString *imgName;
                        
                        if (index == idx) {
                            NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                            imgName = [name replace:@"off" withString:@"on"];
                            
                        }
                        
                        else if(weakSelf.currentIndex == idx) {
                            NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                            imgName = [name replace:@"on" withString:@"off"];
                        }
                        if (imgName) {
                            item.titleIconView.image = [UIImage imageNamed:imgName];
                        }
                        
                    }];
                    [curItem setSelected:YES];
                    _currentIndex = index;
                }];
            }
        }
        [self setScrollOffset:index];
    }
}


- (void)setScrollOffset:(NSInteger)index
{
    if (_contentView.contentSize.width <= kScreen_Width) {
        return;
    }
    
    CGRect rect = [_itemFrames[index] CGRectValue];
    
    float midX = CGRectGetMidX(rect);
    
    float offset = 0;
    
    float contentWidth = _contentView.contentSize.width;
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    
    [UIView animateWithDuration:SegControlAnimationTime animations:^{
        [_contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

int ExceMinIndex(float f)
{
    int i = (int)f;
    if (f != i) {
        return i+1;
    }
    return i;
}




@end
