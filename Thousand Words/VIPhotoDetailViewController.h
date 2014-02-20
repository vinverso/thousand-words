//
//  VIPhotoDetailViewController.h
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface VIPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo * photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;

@end
