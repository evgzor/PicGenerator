//
//  UtilsHelper.m
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "UtilsHelper.h"


@implementation NSArray(utils)


-(void)applySelector:(SEL)selector withArgument:(id)object
{
    [self enumerateObjectsUsingBlock:^(id element, NSUInteger index, BOOL *stop){
        //SEL selector = NSSelectorFromString(@"someMethod");
        if ([element respondsToSelector:selector]) {
            IMP imp = [element methodForSelector:selector];
            void (*func)(id, SEL,id) = (void *)imp;
            func(element, selector,object);
        }
    }];
}


@end


@implementation UIImage(drawText)

-(UIImage*) drawText:(NSString*) text
             atPoint:(CGPoint)   point withFontSize:(CGFloat)fontSize andTextColor:(UIColor*)textColor andBackgroundColor:(UIColor*)backgroundColor;
{
    
    NSMutableAttributedString *textStyle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",text]];
    
    // text color
    [textStyle addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, textStyle.length)];
    
    // text font
    [textStyle addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, textStyle.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [textStyle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStyle.length)];
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0,0, self.size.width, self.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    [[UIColor whiteColor] set];
    
    // add text onto the image
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat red,green,blue,alpha;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGContextSetRGBFillColor(context, red, blue, green, alpha);
    CGContextFillRect(context, rect);
    
    [textStyle drawInRect:CGRectIntegral(rect)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end

@implementation UtilsHelper


@end
