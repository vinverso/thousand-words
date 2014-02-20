//
//  VIAlbumTableViewController.h
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIAlbumTableViewController : UITableViewController 

@property (strong, nonatomic) NSMutableArray * albums;

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
