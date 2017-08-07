//
//  Course+CoreDataProperties.m
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "Course+CoreDataProperties.h"

@implementation Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Course"];
}

@dynamic about;
@dynamic areaName;
@dynamic code;
@dynamic college;
@dynamic department;
@dynamic name;
@dynamic numOfUnits;
@dynamic subArea;
@dynamic area;

@end
