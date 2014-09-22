//
//  BIDPhotosCollectionViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 9/21/14.
//
//

#import "BIDPhotosCollectionViewController.h"
#import "BIDPhotosCollectionViewCell.h"
#import "BIDPhotoViewController.h"
#import "Utils.h"



@interface BIDPhotosCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end


@implementation BIDPhotosCollectionViewController

@synthesize photosArray;
NSString* userIdInPhotosController = @"";
NSIndexPath * indexPath1=0;

static NSString * const reuseIdentifier = @"photosTableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    userIdInPhotosController = [[Utils getInstance]getLoggedInUserId];
    
   // isRemoveFromFriendsRequestSent = NO;
   // self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    
    // Do any additional setup after loading the view.
}

-(void) setupNavigationAndStatusBar{
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.view.backgroundColor = [[Utils getInstance]greenColor];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    self.navigationController.navigationBar.barTintColor = [[Utils getInstance]greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationAndStatusBar];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = @"Photos";
    photosArray = [[Utils getInstance]getUserPhotosFromPrefs];
  
  //  [self.collectionView reloadData];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString *CellIdentifier = @"photosTableCell";
 
   BIDPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSMutableDictionary *result =[photosArray objectAtIndex: [indexPath row]];
    
   // [cell.imageView setImage:[UIImage imageNamed:@"default_user1.jpg"]];
   // NSURL *URL = [NSURL URLWithString:result[@"photoUrl"]]; //TO CHANGE!
    
    NSURL * URL=  [[Utils getInstance]getSaycheesePictureUrl:result[@"photoUrl"] userId:userIdInPhotosController];
   // cell.imageView.imageURL = URL;
      
    cell.imageView.image = [UIImage imageNamed:@"default_user1.jpg"];
    
    cell.imageView.imageURL = URL;

    
    return cell;
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"photoDetailsSequeIdentifier"])
    {
        BIDPhotoViewController *photoViewController =
        [segue destinationViewController];
        
     //   NSIndexPath *myIndexPath = [self.collectionView  inde];
        
        NSDictionary *result =[photosArray objectAtIndex: [indexPath1 row]];
        
        
        photoViewController.photoModel = [[NSDictionary alloc]
                                          initWithDictionary:result];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    indexPath1 = indexPath;
    [[[self.navigationController viewControllers] lastObject] performSegueWithIdentifier:@"photoDetailsSequeIdentifier" sender:self];

}

@end
