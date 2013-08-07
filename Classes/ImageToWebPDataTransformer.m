//  ImageToWebPDataTransformer.m
//
//  Created by Dmitry Shmidt on 01.08.13.
//  Copyright (c) 2013 Dmitry Shmidt. All rights reserved.

#import "ImageToWebPDataTransformer.h"
#import "UIImage+WebP.h"
@implementation ImageToWebPDataTransformer

+ (Class)transformedValueClass 
{
    return NSData.class;
}

+ (BOOL)allowsReverseTransformation 
{
    return YES; 
}

- (id)transformedValue:(id)value 
{
    if (value == nil)
        return nil;

    if ([value isKindOfClass:NSData.class])
        return value;
    
    return [(UIImage *)value dataWebPWithQuality:75];//75 is default by Google
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithWebPData:(NSData *)value];
}

@end
