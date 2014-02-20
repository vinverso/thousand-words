//
//  VIPictureDataTranformer.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VIPictureDataTranformer.h"

@implementation VIPictureDataTranformer

+(Class)transformedValueClass
{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}

-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    UIImage * image = [UIImage imageWithData:value];
    return image;
}

@end
