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

@interface GSItemTableVIewCell ()
@property (nonatomic, retain) UIImageView *avatar;
@property (nonatomic, retain) UILabel *author;
@property (nonatomic, retain) UILabel *text;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *via;
@end

@implementation GSItemTableVIewCell
@synthesize avatar = _avatar;
@synthesize author = _author;
@synthesize text = _text;
@synthesize item = _item;
@synthesize date = _date;
@synthesize via = _via;

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
        //self.backgroundView.layer.cornerRadius = 6.0f;
        
        //title
        self.avatar = [[[UIImageView alloc] init] autorelease];
        //self.avatar.layer.cornerRadius = 6.0f;
        //self.avatar.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatar];
        
        self.author = [[[UILabel alloc] init] autorelease];
        self.author.font = [UIFont boldSystemFontOfSize:12.0f];
        self.author.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.author];
        
        self.date = [[[UILabel alloc] init] autorelease];
        self.date.font = [UIFont systemFontOfSize:12.0f];
        self.date.backgroundColor = [UIColor clearColor];
        self.date.textAlignment = UITextAlignmentRight;
        self.date.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.date];
        
        self.via = [[[UILabel alloc] init] autorelease];
        self.via.font = [UIFont systemFontOfSize:12.0f];
        self.via.backgroundColor = [UIColor clearColor];
        self.via.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.via];

        self.text = [[[UILabel alloc] init] autorelease];
        self.text.numberOfLines = 3;
        self.text.font = [UIFont systemFontOfSize:12.0f];
        self.text.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.text];
    }
    return self;
}

- (void)dealloc
{
    [_avatar release];
    [_author release];
    [_text release];
    [_item release];
    [_date release];
    [_via release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(0, 5.0f, self.bounds.size.width, self.bounds.size.height - 10.0f);
    [self.imageView setFrame:CGRectMake(5.0f, self.bounds.size.height - 320.0f, 310.0f, 310.0f)];
    [self.avatar setFrame:CGRectMake(5.0f, 10.0f, 40.0f, 40.0f)];
    [self.date setFrame:CGRectMake(self.bounds.size.width - 110.0f, 10.0f, 100.0f, 12.0f)];
    CGSize authorSize = [self.item.author sizeWithFont:self.author.font 
                                     constrainedToSize:CGSizeMake(265.0f,100.0f) 
                                         lineBreakMode:self.author.lineBreakMode];
    [self.author setFrame:CGRectMake(50.0f, 10.0f, authorSize.width, 12.0f)]; 
    [self.via setFrame:CGRectMake(55.0f + authorSize.width, 10.0f, 60.0f, 12.0f)];
    
    CGSize textSize = [self.item.text sizeWithFont:self.text.font 
                                          constrainedToSize:CGSizeMake(265.0f,100.0f) 
                                              lineBreakMode:self.text.lineBreakMode]; 
    [self.text setFrame:CGRectMake(50.0f, 22.0f, textSize.width, textSize.height)];
}

#pragma mark - properties

- (void)setItem:(GSItem *)item
{
    if (item != _item) {
        [_item release];
        _item = [item retain];
        [self.imageView setImageWithURL:_item.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [self.avatar setImageWithURL:_item.avatarURl placeholderImage:[UIImage imageNamed:@"placeholde.png"]];
        self.author.text = _item.author;
        self.text.text = _item.text;
        self.date.text = [_item.date stringWithTimeDifference];
        self.via.text = [NSString stringWithFormat:@"via %@", _item.via];
    }
}
@end
