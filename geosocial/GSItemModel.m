//
//  GSItemModel.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "GSItemModel.h"
#import <AFNetworking/AFNetworking.h>
#import "Items.h"
#import "Media.h"

@interface GSItemModel()
- (void)putItemsToCoreDataFromArray:(NSArray*)arr;
@end

@implementation GSItemModel
- (void)loadItems
{
    NSURL *url = [NSURL URLWithString:@"http://geostreams.appspot.com/stream?lat=54.32&lng=48.32&rds=10"];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    for (NSDictionary *info in arr) {
        if ([[Items findByAttribute:@"itemId" withValue:[NSString stringWithFormat:@"%@", [info valueForKey:@"id"]]] count] == 0) {
            Items *item = [Items createEntity];
            item.profileImageUrl = [info valueForKey:@"profile_image_url"];
            item.text = [info valueForKey:@"text"];
            item.fromUser = [info valueForKey:@"from_user"];
            item.fromUserName = [info valueForKey:@"from_user_name"];
            item.sourceType = [info valueForKey:@"source_type"];
            item.fromUserId = [NSString stringWithFormat:@"%@", [info valueForKey:@"from_user_id"]];
            item.createdAt = [dateFormatter dateFromString:[info valueForKey:@"created_at"]];
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
    [dateFormatter release];
}
@end
