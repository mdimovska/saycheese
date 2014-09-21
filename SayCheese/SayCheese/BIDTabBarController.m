//
//  BIDTabBarController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import "BIDTabBarController.h"
#import "Utils.h"

@interface BIDTabBarController ()

@end

@implementation BIDTabBarController

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
    self.navigationController.view.tintColor = [[Utils getInstance] greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    return [self.selectedViewController prepareForSegue:segue sender:sender];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}
-(BOOL) shouldAutorotate {
    return YES;
}

@end