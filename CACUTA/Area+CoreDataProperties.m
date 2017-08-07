//
//  Area+CoreDataProperties.m
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "Area+CoreDataProperties.h"

@implementation Area (CoreDataProperties)

+ (NSFetchRequest<Area *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Area"];
}

@dynamic about;
@dynamic minRequierdUnits;
@dynamic name;
@dynamic notes;
@dynamic numOfSections;
@dynamic title;
@dynamic courses;
@dynamic coursesList;

@end
