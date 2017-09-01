//
//  Clothes+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by 欧阳群峰 on 2017/8/31.
//  Copyright © 2017年 肖疆维. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Clothes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Clothes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *types;

@end

NS_ASSUME_NONNULL_END
