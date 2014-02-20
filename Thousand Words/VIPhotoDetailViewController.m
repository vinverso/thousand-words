//
//  VIPhotoDetailViewController.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VIPhotoDetailViewController.h"
#import "Photo.h"
#import "VIFiltersCollectionViewController.h"

@interface VIPhotoDetailViewController ()

@end

@implementation VIPhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.imageView.image = self.photo.image;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
    
    
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[self.photo managedObjectContext] deleteObject:self.photo];
    
    NSError * error = nil;
    
    if (![[self.photo managedObjectContext] save:&error]){
        //error in saving
        NSLog(@"%@", error);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[VIFiltersCollectionViewController class]]){
        if ([segue.identifier isEqualToString:@"Filter segue"]){
            VIFiltersCollectionViewController * next = segue.destinationViewController;
            next.photo1 = self.photo;
        }
    }
}







@end























