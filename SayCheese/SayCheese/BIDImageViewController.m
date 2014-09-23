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
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"

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
    [self.navigationItem setHidesBackButton:YES];
    isPhotoDeleted=NO;
    
    // Do any additional setup after loading the view.
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
    
    //black transparent status bar
    //this covers navigation bar too
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,800, 64)]; //20 only for status bar
    view.backgroundColor= [UIColor  colorWithRed:((float) 0.0f)
                                           green:((float) 0.0f)
                                            blue:((float) 0.0f)
                                           alpha:0.5];
    
    if(image!=NULL){
        [imageView setImage:image];
        //set constrains to center and scale the image
       imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self.view addSubview:view];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillDisappear:animated];
}

- (IBAction)savePhotoToServer:(id)sender
{
    
    if(!isPhotoDeleted){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self sendPhotoToServer];
    }
    
}


-(void) sendPhotoToServer
{
    NSDictionary* userDictionary = [[Utils getInstance]getUserDictionary];
    NSString* filename = [self formNameOfPhoto:userDictionary[@"user"][@"id"]];
    NSLog(@"Name of photo: %@)", filename);
    
     NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *url = [[Utils getInstance] uploadPhotoUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",userDictionary[@"user"][@"id"]] forKey:@"_id"];
    [_params setObject:[NSString stringWithFormat:@"%@",userDictionary[@"user"][@"first_name"]] forKey:@"firstName"];
    [_params setObject:[NSString stringWithFormat:@"%@",userDictionary[@"user"][@"last_name"]] forKey:@"lastName"];
    [_params setObject:[NSString stringWithFormat:@"%f", image.size.width] forKey:@"photoWidth"];
    [_params setObject:[NSString stringWithFormat:@"%f", image.size.height] forKey:@"photoHeight"];
    [_params setObject:[NSString stringWithFormat:@"%@", filename] forKey:@"photoUrl"];
    [_params setObject:[NSString stringWithFormat:@"%@", @""] forKey:@"caption"]; //FIX THIS: add caption
    
       manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          [formData appendPartWithFileData:imageData name:@"path" fileName:filename mimeType:@"image/jpeg"];
      
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful upload of photo: %@", responseObject);
        [view removeFromSuperview];
        //image is wriiten to photo album if it's not deleted
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in uploading photo: %@", error);
        [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not save photo"];
        // isCancelRequestSent = NO;

    }];
    
}

- (NSString *) formNameOfPhoto: userId
{
    NSString *dateString;
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmssSSS"];
	dateString = [dateFormatter stringFromDate:now];
	return [[userId stringByAppendingString:dateString] stringByAppendingString: @".jpg"];
}


- (IBAction)btnShowHideNavigationBarClick:(id)sender {
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


- (IBAction)deletePhotoActionSheet:(id)sender {
    isActionSheetDeleteShown = YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete Photo", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (void) shareToTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        //   [tweetSheet setInitialText:text];
        [tweetSheet addImage:image];
        //  if (venueUrl != NULL)
        //      [tweetSheet addURL:[NSURL URLWithString:venueUrl]];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Post Canceled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    break;
                default:
                    break;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Completion Message"
                                                            message:output
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure                                   your device has an internet connection and you have                                   at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) shareToFacebook{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller addImage:image];
        
        // if (venueUrl != NULL)
        //   [controller addURL:[NSURL URLWithString:venueUrl]];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Post Canceled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    break;
                default:
                    break;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Completion Message"
                                                            message:output
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        //    [controller setInitialText:text];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't post right now, make sure                                   your device has an internet connection and you have                                   at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
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

/*
 -(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
 NSLog(@"willAnimateRotationToInterfaceOrientation");
 }
 */

- (IBAction)sharePhoto:(id)sender {
    isActionSheetDeleteShown = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}

@end