//
//  VICoreDataHelper.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VICoreDataHelper.h"

@implementation VICoreDataHelper

+(NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext * context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    
    
    //introspection - managedObjectContext method only works if started with core data template
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    
    return context;
}

@end
