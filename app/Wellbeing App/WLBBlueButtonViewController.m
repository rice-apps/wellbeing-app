//
//  WLBBlueButtonViewController.m
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/02/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBBlueButtonViewController.h"
@import MapKit;

@interface WLBBlueButtonViewController ()

@end

@implementation WLBBlueButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    // if logged in user is a policeman, make button hidden, map visible.
    //if policeman visible, hide button, load all users who have emergency on map.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@import CoreLocation;

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];

    [map addAnnotation: annotation];
    
    return map;
}

- (IBAction)callButtonPush:(id)sender {
    NSLog(@"RUPD successfully requested.");
    
    NSURL *url = [NSURL URLWithString:@"telprompt://713-367-7602"];
    [[UIApplication  sharedApplication] openURL:url];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   
    //Making a post request of Latitude and Longitude.
    NSString *post = [NSString stringWithFormat:@"Latitude=%@&Longitude=%@",@"latitude",@"longitude"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    
    
    
    

}
@end
