//
//  GSItem.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "GSItem.h"

@implementation GSItem
@synthesize author = _author;
@synthesize avatarURl = _avatarURl;
@synthesize hasText = _hasText;
@synthesize imageURL = _imageURL;
@synthesize text = _text;
@synthesize date = _date;
@synthesize via = _via;

- (void)dealloc
{
    [_author release];
    [_avatarURl release];
    [_imageURL release];
    [_text release];
    [_date release];
    [_via release];
    [super dealloc];
}

#pragma mark - properties

- (BOOL)hasText
{
    return ![self.text isEqualToString:@""];
}

- (BOOL)hasImage
{
    return self.imageURL ? YES : NO;
}

@end
