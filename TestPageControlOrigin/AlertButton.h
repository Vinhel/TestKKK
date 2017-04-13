//
//  AlertButton.h
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertButtonType)
{
    AlertButtonNone,
    AlertButtonSelector
};

typedef NSDictionary* (^CompleteButtonFormatBlock)(void);
typedef NSDictionary* (^ButtonFormatBlock)(void);

@interface AlertButton : UIButton

@property (copy, nonatomic) CompleteButtonFormatBlock completeButtonFormatBlock;

@end
