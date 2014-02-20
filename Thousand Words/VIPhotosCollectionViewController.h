//
//  VIPhotosCollectionViewController.h
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface VIPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album * album;

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
