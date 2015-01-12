//
//  WLBNightEscortViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 10/6/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBNightEscortViewController.h"

@interface WLBNightEscortViewController ()

@end

@implementation WLBNightEscortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    // center on user
    CLLocationCoordinate2D riceLocation = CLLocationCoordinate2DMake(29.7169, -95.4028);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(riceLocation, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    self.locationController = [[WLBCoreLocationController alloc] init];
    self.locationController.delegate = self;
    [self.locationController.locationManager requestAlwaysAuthorization];
    [self.locationController.locationManager startUpdatingLocation];
    
    self.busMarker.title = @"Night Escort";
    
#warning TODO: popup message and stop timer? if no coordinates. or keep track of times when bus is available
    
    // begin timer for getting bus location
    NSTimer *busTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(pollForBusLocation:) userInfo:nil repeats:YES];
    [busTimer fire];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"hi");
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}

- (void)pollForBusLocation:(NSTimer*)busTimer {
    // get bus locations via GET request to indicated URL
    NSURLRequest *getBusRequest=[NSURLRequest
                              requestWithURL:[NSURL URLWithString:@"http://bus.rice.edu/json/buses.php"]
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:2.0];
    NSData *busJSON = [NSURLConnection sendSynchronousRequest:getBusRequest returningResponse:nil error:nil];
    NSArray *busLocations = [NSJSONSerialization JSONObjectWithData:busJSON options:NSJSONReadingMutableLeaves error:nil][@"d"];
    
    [self extractBusLocation:busLocations];
}

- (void)extractBusLocation:(NSArray*)busLocations {
#warning TODO: change to return coordinates or NIL
    // iterate through all buses to find Night Escort
    NSDictionary *nightBus = nil;
    for (int i = 0; i < busLocations.count; i++) {
        if ([busLocations[i][@"Name"]  isEqual: @"Night Escort Service"]) {
            nightBus = busLocations[i];
            break;
        }
    }
    if (nightBus == nil) {
#warning TODO: show something on screen to let people know
        NSLog(@"No night bus currently found");
        return;
    }
    
    CLLocationCoordinate2D busCoordinates;
    busCoordinates.longitude = (CLLocationDegrees)[[nightBus objectForKey:@"Longitude"] doubleValue];
    busCoordinates.latitude = (CLLocationDegrees)[[nightBus objectForKey:@"Latitude"] doubleValue];
    NSLog(@"bye");
    self.busMarker.coordinate = busCoordinates;
    [self.mapView addAnnotation:self.busMarker];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
