//
//  BIDImageViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/15/14.
//
//

#import "BIDImageViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface BIDImageViewController ()

@end

@implementation BIDImageViewController
@synthesize image;
@synthesize jpegData;
@synthesize imageView;
UIView *view;
BOOL isPhotoDeleted;

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
    isPhotoDeleted=NO;
   // CGRect r = self.imageView.frame;

    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(result.height == 480)
    {
        // iPhone Classic
     //   r.size.height = 480;
        // self.view.frame =  CGRectMake(0, 0, 320, 480);
      //   imageView.frame = CGRectMake(0, 0, 320, image.size.height);
    }
    if(result.height == 568)
    {
        // iPhone 5
     //   r.size.height =568;
        //self.view.frame =  CGRectMake(0, 0, 320, 568);
        // imageView.frame = CGRectMake(0, 0, 320,  image.size.height);
    }
    
    // Do any additional setup after loading the view.
   [self setNeedsStatusBarAppearanceUpdate];
    
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    /*
    self.navigationController.navigationBar.backgroundColor = [UIColor  colorWithRed:((float) 0.0f)
                                                                               green:((float) 0.0f)
                                                                                blue:((float) 0.0f)
                                                                               alpha:0.5];
     */
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //black transparent status bar
    //this covers navigation bar too
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,800, 64)]; //20 only for status bar
    view.backgroundColor= [UIColor  colorWithRed:((float) 0.0f)
                                           green:((float) 0.0f)
                                            blue:((float) 0.0f)
                                           alpha:0.5];
    
    [self addImageView];
    [self.view addSubview:view]; ////black transparent status bar and navigation bar
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

-(void)addImageView{
    if(image!=NULL){
      //  imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
        
        float cameraAspectRatio = 4.0 / 3.0;
        float imageWidth = [[UIScreen mainScreen]bounds].size.height / cameraAspectRatio;
       // imageView.frame =CGRectMake(0, 0, imageWidth, [[UIScreen mainScreen] bounds].size.height);
        
      //  [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        
      //  [imageView setImage:image];
        
      //  imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //new
        imageView=[[UIImageView alloc] initWithImage:image];
         self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:imageView];
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:4.0/3.0 constant:0.0f];
            
            [self.imageView addConstraint:constraint];
        }
        else{
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:4.0/3.0 constant:0.0f];
            
            [self.imageView addConstraint:constraint];
        }
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated{
    [view removeFromSuperview];
    //image is wriiten to photo album if it's not deleted
    if(!isPhotoDeleted){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [super viewWillDisappear:animated];
}

- (IBAction)btnShowHideNavigationBarClick:(id)sender {
    // show/hide nav bar
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [view setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [view setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}


- (IBAction)deletePhotoActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete Photo", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //btn delete clicked
        [self deletePhoto];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    //[[actionSheet layer] setBackgroundColor:[UIColor grayColor].CGColor];
    
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(102/255.0) blue:(85/255.0) alpha:1];
        }
    }];
}

-(void) deletePhoto{
     isPhotoDeleted=YES;
     [self.navigationController popViewControllerAnimated:YES];
}

-(void) dealloc{
    [image release];
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAllButUpsideDown);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait );
}

-(BOOL) shouldAutorotate {
    
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    
 //   CGAffineTransform rotate = CGAffineTransformMakeRotation( 1.0 / 180.0 * 3.14 );
   // [imageView setTransform:rotate];
    
    // float imageWidth = [[UIScreen mainScreen]bounds].size.height / cameraAspectRatio;
    //imageView.frame =CGRectMake(0, 0, imageWidth, [[UIScreen mainScreen] bounds].size.height);
    float cameraAspectRatio = 4.0 / 3.0;
    float screenHeight =[[UIScreen mainScreen]bounds].size.height; //480
    float imageHeight =  screenHeight/ cameraAspectRatio; //360
    
    if(toInterfaceOrientation==UIInterfaceOrientationPortrait){
      //  imageView.frame =CGRectMake(0, 0, imageHeight, [[UIScreen mainScreen] bounds].size.height);
    }
    else{
      //   imageView.frame =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, imageHeight);
    }
    
    
 //   imageView.frame =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, imageHeight);
  
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
  //   imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

@end