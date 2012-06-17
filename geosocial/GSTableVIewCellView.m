//
//  GSTableVIewCellView.m
//  geosocial
//
//  Created by Иван Ушаков on 17.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "GSTableVIewCellView.h"
#import <NSDate-TimeDifference/NSDate+TimeDifference.h>

@implementation GSTableVIewCellView
@synthesize item = _item;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize authorSize = [self.item.fromUser sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]
                                       constrainedToSize:CGSizeMake(265.0f,100.0f) 
                                           lineBreakMode:UILineBreakModeWordWrap];
    [self.item.fromUser drawInRect:CGRectMake(50.0f, 4.0f, authorSize.width, 12.0f) withFont:[UIFont boldSystemFontOfSize:12.0f]]; 

    [[UIColor grayColor] set];
    
    [[NSString stringWithFormat:@"via %@", self.item.sourceType] drawInRect:CGRectMake(55.0f + authorSize.width, 4.0f, 100.0f, 12.0f)
                                                                   withFont:[UIFont systemFontOfSize:12.0f]];

    [[self.item.createdAt stringWithTimeDifference] drawInRect:CGRectMake(self.bounds.size.width - 110.0f, 4.0f, 100.0f, 12.0f) 
                                                      withFont:[UIFont systemFontOfSize:12.0f] 
                                                 lineBreakMode:UILineBreakModeWordWrap 
                                                     alignment:UITextAlignmentRight];
    
    [[UIColor blackColor] set];
    
    CGSize textSize = [self.item.text sizeWithFont:[UIFont systemFontOfSize:12.0f] 
                                 constrainedToSize:CGSizeMake(265.0f,100.0f) 
                                     lineBreakMode:UILineBreakModeWordWrap]; 
    [self.item.text drawInRect:CGRectMake(50.0f, 20.0f, textSize.width, textSize.height) withFont:[UIFont systemFontOfSize:12.0f]];
}

#pragma mark - properties

- (void)setItem:(Items *)item
{
    if (item != _item) {
        [_item release];
        _item = [item retain];
        [self setNeedsDisplay];
    }
}

@end
