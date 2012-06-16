//
//  GSItem.h
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSItem : NSObject
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSURL *avatarURl;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, readonly) BOOL hasText;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *via;
@end
