//
//  GSItemTableVIewCell.h
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Items.h"

@interface GSItemTableVIewCell : UITableViewCell
@property (nonatomic, retain) Items *item;
+ (CGFloat)heightForCellWithItem:(Items*)item;
@end
