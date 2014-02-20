//
//  Photo.h
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Album *albumBook;

@end
