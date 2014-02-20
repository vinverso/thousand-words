//
//  VIFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/19/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VIFiltersCollectionViewController.h"
#import "VIPhotoCollectionViewCell.h"
#import "Photo.h"

@interface VIFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray * filters;
@property (strong, nonatomic) CIContext * context;

@end

@implementation VIFiltersCollectionViewController

-(NSMutableArray *) filters
{
    if (!_filters){
        _filters = [[NSMutableArray alloc]init];
    }
    return _filters;
}

-(CIContext *) context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter*)filter
{
    CIImage * unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage * filteredImage = [filter outputImage];
    
    CGRect extent = [filteredImage extent];
    
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    
    UIImage * finalImage = [UIImage imageWithCGImage:cgImage];
    
    return finalImage;
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
    
    self.filters = [[self createFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * iD = @"Cell";
    
    VIPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:iD forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    
    dispatch_async(filterQueue, ^{
        UIImage * filterImage = [self filteredImageFromImage:self.photo1.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImage;
        });
    });
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}


#pragma mark - helpers

-(NSArray *) createFilters
{
    CIFilter * sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
    CIFilter * blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    CIFilter * colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents",[CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter * instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:nil];
    CIFilter * noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues:nil];
    CIFilter * vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:nil];
    CIFilter * colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    CIFilter * transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    CIFilter * unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    CIFilter * monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    
                             
    NSArray * allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome];
    
    return allFilters;
}

#pragma mark - UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VIPhotoCollectionViewCell * selected = (VIPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.photo1.image = selected.imageView.image;
    
    if (self.photo1.image) {
        NSError * error = nil;
        
        if (![[self.photo1 managedObjectContext] save:&error]){
            NSLog(@"%@", error);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}












@end
