//
//  VIPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VIPhotosCollectionViewController.h"
#import "VIPhotoCollectionViewCell.h"
#import "Photo.h"
#import "VIPictureDataTranformer.h"
#import "VICoreDataHelper.h"
#import "VIPhotoDetailViewController.h"

@interface VIPhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation VIPhotosCollectionViewController


-(NSMutableArray *) photos
{
    if (!_photos){
        _photos = [[NSMutableArray alloc]init];
    }
    return _photos;
}




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


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSSet * unorderedPhotos = self.album.photos;
    NSSortDescriptor * dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Date" ascending:YES];
    NSArray * sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Photo detail segue"]){
        if([segue.destinationViewController isKindOfClass:[VIPhotoDetailViewController class]]){
            VIPhotoDetailViewController * nextVC = segue.destinationViewController;
            NSIndexPath * iP = [[self.collectionView indexPathsForSelectedItems]lastObject];
            Photo * selectedPhoto = self.photos[iP.row];
            nextVC.photo = selectedPhoto;
        }
    }
}

#pragma mark - helper methods

-(Photo *)photoFromImage:(UIImage*)image
{
    Photo * photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[VICoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    NSError * error = nil;
    
    if (![[photo managedObjectContext] save:&error]){
        //error in saving
        NSLog(@"%@", error);
    }
    return photo;
}


#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * cellIdentifier = @"Photo Cell";
    
    VIPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Photo * photo = self.photos[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = photo.image;
    
    return cell;
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}




- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}




#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    [self.photos addObject:[self photoFromImage:image]];
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end















