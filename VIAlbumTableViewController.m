//
//  VIAlbumTableViewController.m
//  Thousand Words
//
//  Created by Vincent Inverso on 2/18/14.
//  Copyright (c) 2014 Vincent Inverso. All rights reserved.
//

#import "VIAlbumTableViewController.h"
#import "Album.h"
#import "VICoreDataHelper.h"
#import "VIPhotoCollectionViewCell.h"
#import "VIPhotosCollectionViewController.h"

@interface VIAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation VIAlbumTableViewController

-(NSMutableArray*)albums
{
    if (!_albums){
        _albums = [[NSMutableArray alloc]init];
    }
    return _albums;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError * error = nil;
    
    NSArray *fetchedAlbums = [[VICoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.albums = [fetchedAlbums mutableCopy];
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -IBActions

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender {
    UIAlertView *newAlbumAlertview = [[UIAlertView alloc]initWithTitle:@"enter album title" message:nil
                                                              delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"add", nil];
    [newAlbumAlertview setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertview show];
    
    
}





#pragma mark - helper methods

-(Album*)albumWithName: (NSString*)name
{
    //use our helper method
    NSManagedObjectContext * context = [VICoreDataHelper managedObjectContext];
    
    Album * album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    
    NSError * error = nil;
    if (![context save:&error]){
        //error
        NSLog(@"%@", error);
    }
    return album;
}




#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString * alertText = [alertView textFieldAtIndex:0].text;
        Album * newAlbum = [self albumWithName:alertText];
        [self.albums addObject:newAlbum];
        //loads the new row into the table view and obviates the
        //need for reloading the entire table
        //model and tableView must match after this method is called
        [self.tableView insertRowsAtIndexPaths:
         @[[NSIndexPath indexPathForRow:[self.albums count]-1
                              inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.albums count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Album * a = self.albums[indexPath.row];
    cell.textLabel.text = a.name;
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[VIPhotosCollectionViewController class]]) {
        if ([segue.identifier isEqualToString:@"Album selected"]) {
            
            NSIndexPath * path = [self.tableView indexPathForSelectedRow];
            VIPhotosCollectionViewController * nextVC = segue.destinationViewController;
            
            nextVC.album = self.albums[path.row];
        }
    }
}



@end

































