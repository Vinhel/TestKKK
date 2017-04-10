//
//  NSString+customString.m
//  SONICPITNew
//
//  Created by noah on 2017/03/13.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "NSString+customString.h"
#import <CoreGraphics/CGGeometry.h>

@implementation NSString (customString)

- (NSString *)replace:(NSString *)str0 withString:(NSString *)str1
{

    NSMutableString *string= self.mutableCopy;
    [string replaceOccurrencesOfString:str0 withString:str1 options:NSBackwardsSearch range:NSMakeRange(self.length-3,3)];
    return string.copy;
}



- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

- (NSString *)arrayConvertToString:(NSArray *)arr
{
    NSString *returnString;
    for (NSString *str in arr)
    {
        returnString = [NSString stringWithFormat:@"%@\n\n%@", returnString, str];
    }
    return returnString;
}



@end
