//
//  GSItemModel.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "GSItemModel.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "Items.h"
#import "Media.h"

@interface GSItemModel()
@property (nonatomic, retain) CLLocationManager *locationManager;
- (void)putItemsToCoreDataFromArray:(NSArray*)arr;
@end

@implementation GSItemModel
@synthesize locationManager = _locationManager;

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)dealloc
{
    [_locationManager release];
    [super dealloc];
}

- (void)loadItems
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://geostreams.appspot.com/stream?lat=%lf&lng=%lf&rds=10", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self putItemsToCoreDataFromArray:JSON];
                                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:GS_ITEM_MODEL_FINISH_LOAD_ITEMS object:self];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){   
                                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:GS_ITEM_MODEL_FINISH_LOAD_ITEMS object:self];
                                                                                        }];
    [operation start];
}

- (void)putItemsToCoreDataFromArray:(NSArray*)arr;
{
    for (NSDictionary *info in arr) {
        if ([[Items findByAttribute:@"itemId" withValue:[NSString stringWithFormat:@"%@", [info valueForKey:@"id"]]] count] == 0) {
            Items *item = [Items createEntity];
            item.profileImageUrl = [info valueForKey:@"profile_image_url"];
            item.text = [info valueForKey:@"text"];
            item.fromUser = [info valueForKey:@"from_user"];
            item.fromUserName = [info valueForKey:@"from_user_name"];
            item.sourceType = [info valueForKey:@"source_type"];
            item.fromUserId = [NSString stringWithFormat:@"%@", [info valueForKey:@"from_user_id"]];
            item.createdAt = [NSDate dateWithTimeIntervalSince1970:[[info valueForKey:@"timestamp"] floatValue]];
            item.itemId = [NSString stringWithFormat:@"%@", [info valueForKey:@"id"]];
            
            NSArray *media = [[info valueForKey:@"entities"] valueForKey:@"media"];
            for (NSDictionary *mediaInfo in media) {
                Media *media = [Media createEntity];
                media.url = [mediaInfo valueForKey:@"url"];
                media.type = [mediaInfo valueForKey:@"type"];
                media.width = [[[mediaInfo valueForKey:@"sizes"] valueForKey:@"large"] valueForKey:@"w"];
                media.height = [[[mediaInfo valueForKey:@"sizes"] valueForKey:@"large"] valueForKey:@"h"];
                [item addMediaObject:media];
            }
        }
    }
}
@end
