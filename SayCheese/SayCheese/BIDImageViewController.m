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
@synthesize toolbar;
UIView *view;
BOOL isPhotoDeleted;
BOOL isActionSheetDeleteShown = NO;

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
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //black transparent status bar and navigation bar
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,800, 64)];
    view.backgroundColor= [UIColor  colorWithRed:((float) 0.0f)
                                           green:((float) 0.0f)
                                            blue:((float) 0.0f)
                                           alpha:0.5];
    
    [self addImageView];
    [self.view addSubview:view];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

-(void)addImageView
{
    if(image!=NULL){
        [imageView setImage:image];
        
        //set constrains to center and scale the image
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self setConstraints];
    }
}

- (void) setConstraints
{
    if(([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)|| ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)){
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeWidth multiplier:4.0/3.0 constant:0.0f];
        
        [imageView addConstraint:constraint];
    }
    else{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:4.0/3.0 constant:0.0f];
        
        [imageView addConstraint:constraint];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
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

- (void)viewWillDisappear:(BOOL)animated
{
    [view removeFromSuperview];
    //image is wriiten to photo album if it's not deleted
    if(!isPhotoDeleted){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillDisappear:animated];
}

- (IBAction)btnShowHideNavigationBarClick:(id)sender
{
    // show/hide nav bar and toolbar
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [view setHidden:YES];
        [toolbar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [view setHidden:NO];
        [toolbar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}


- (IBAction)deletePhotoActionSheet:(id)sender
{
    isActionSheetDeleteShown = YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete Photo", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isActionSheetDeleteShown){
        if (buttonIndex == 0) {
            //btn delete clicked
            [self deletePhoto];
        }
    }else{
        //share action sheet
        if (buttonIndex == 0) {
            [self shareToTwitter];
        } else if (buttonIndex == 1){
            [self shareToFacebook];
        }
    }
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(102/255.0) blue:(85/255.0) alpha:1];
        }
    }];
}

-(void) deletePhoto
{
    isPhotoDeleted=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) shareToTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
     
        [tweetSheet addImage:image];
    
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    [self showAlertView:output withTitle:@"Twitter Completion Message"];
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [self showAlertView:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                  withTitle:@"Sorry"];
    }
}

- (void) shareToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller addImage:image];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    [self showAlertView:output
                              withTitle:@"Facebook Completion Message"];
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        [self showAlertView:@"ou can't post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                  withTitle:@"Sorry"];
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAllButUpsideDown);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return (UIInterfaceOrientationPortrait );
}

-(BOOL) shouldAutorotate {
    
    return YES;
}

- (IBAction)sharePhoto:(id)sender {
    isActionSheetDeleteShown = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}

- (void) showAlertView: message withTitle: (NSString*) title
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: title
                              message: message
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

@end