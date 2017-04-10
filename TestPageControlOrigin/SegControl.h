//
//  SegControl.h
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/10.
//  Copyright © 2017年 noah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,PageControlType){
    PAGECONTROLFOUR = 0,
    PAGECONTROLFIVE
};
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@class SegControl;

@protocol SegControlDelegate <NSObject>

- (void)segmentControl:(SegControl *)control selectedIndex:(NSInteger)index;

@end

typedef void(^SegControlBlock)(NSInteger index);

@interface SegControl : UIView

@property (nonatomic) NSInteger currentIndex, selectedIndex;

@property (nonatomic) PageControlType checkType;

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem selectedBlock:(SegControlBlock)selectedHandle;


- (void)selectIndex:(NSInteger)index;

@end
