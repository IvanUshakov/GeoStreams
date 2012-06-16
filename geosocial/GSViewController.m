//
//  GSViewController.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "GSViewController.h"
#import "GSItemTableVIewCell.h"

@interface GSViewController ()

@end

@implementation GSViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _item = [[[GSItem alloc] init] autorelease];
        _item.imageURL = [NSURL URLWithString:@"http://distilleryimage3.instagram.com/76c55116b7ad11e18bb812313804a181_7.jpg"];
        _item.text = @"drawing shadows is expensive operation, so for example if your application allows other interface orientation and you start to rotate the de";
        _item.avatarURl = [NSURL URLWithString:@"https://si0.twimg.com/profile_images/2058587904/170_normal.png"];
        _item.author = @"ULmolot";
        
        ISO8601DateFormatter *dateFormator = [[ISO8601DateFormatter alloc] init];
        _item.date = [dateFormator dateFromString:@"Sat, 16 Jun 2012 16:30:36 +0000"];
        [dateFormator release];
        
        _item.via = @"Twitter";
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GSItemTableVIewCellIdentifier = @"GSItemTableVIewCellIdentifier";
    GSItemTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:GSItemTableVIewCellIdentifier];
    if (!cell) {
        cell = [[[GSItemTableVIewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:GSItemTableVIewCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.item = _item;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
