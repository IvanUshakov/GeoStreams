//
//  Items.h
//  geosocial
//
//  Created by Иван Ушаков on 17.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media;

@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * profileImageUrl;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * fromUser;
@property (nonatomic, retain) NSString * fromUserName;
@property (nonatomic, retain) NSString * sourceType;
@property (nonatomic, retain) NSString * fromUserId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSSet *media;
@end

@interface Items (CoreDataGeneratedAccessors)

- (void)addMediaObject:(Media *)value;
- (void)removeMediaObject:(Media *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
