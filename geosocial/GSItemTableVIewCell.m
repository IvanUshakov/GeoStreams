//
//  GSItemTableVIewCell.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "GSItemTableVIewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import <NSDate-TimeDifference/NSDate+TimeDifference.h>
#import "Media.h"
#import "GSTableVIewCellView.h"

@interface GSItemTableVIewCell ()
@property (nonatomic, retain) UIImageView *avatar;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) GSTableVIewCellView *cellView;
@end

@implementation GSItemTableVIewCell
@synthesize avatar = _avatar;
@synthesize item = _item;
@synthesize media = _media;
@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //background
        self.backgroundView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.backgroundView.layer.masksToBounds = NO;
        self.backgroundView.layer.shadowColor = [[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor];
        self.backgroundView.layer.shadowOffset = CGSizeMake(2, 2);
        self.backgroundView.layer.shadowOpacity = 0.5;
        
        //title
        self.avatar = [[[UIImageView alloc] init] autorelease];
        [self.avatar setFrame:CGRectMake(5.0f, 5.0f, 40.0f, 40.0f)];
        [self.contentView addSubview:self.avatar];
        
        self.cellView = [[GSTableVIewCellView alloc] init];
        [self.contentView addSubview:self.cellView];
    }
    return self;
}

- (void)dealloc
{
    [_avatar release];
    [_item release];
    [_media release];
    [_cellView release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(0, 5.0f, self.bounds.size.width, self.bounds.size.height - 10.0f);
    self.contentView.frame = self.backgroundView.frame;
    if (self.media) {
        self.imageView.hidden = NO;
        [self.imageView setFrame:CGRectMake(5.0f, self.bounds.size.height - 325.0f, 310.0f, 310.0f)];
    }
    else {
        self.imageView.hidden = YES;
    }
    self.cellView.frame = self.contentView.bounds;
}

#pragma mark - properties

- (void)setItem:(Items *)item
{
    if (item != _item) {
        [_item release];
        _item = [item retain];
        self.media = [_item.media anyObject];
        if (self.media && [self.media.type isEqualToString:@"photo"]) {
            [self.imageView setImageWithURL:[NSURL URLWithString:self.media.url]];
        }
        [self.avatar setImageWithURL:[NSURL URLWithString:_item.profileImageUrl]];
        _cellView.item = _item;
    }
}

#pragma mark - static

+ (CGFloat)heightForCellWithItem:(Items*)item
{
    CGSize textSize = [item.text sizeWithFont:[UIFont systemFontOfSize:12.0f] 
                            constrainedToSize:CGSizeMake(265.0f,100.0f) 
                                lineBreakMode:UILineBreakModeWordWrap]; 
    CGFloat size = textSize.height + 5.0f < 30.0f ? 30.0f : textSize.height + 5.0f;
    size += 30.0f;
    Media *media = [item.media anyObject];
    if (media && [media.type isEqualToString:@"photo"]) {
        size += 315.0f;
    }
    return size;
}
@end
