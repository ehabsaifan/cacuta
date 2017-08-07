//
//  University+CoreDataProperties.m
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "University+CoreDataProperties.h"

@implementation University (CoreDataProperties)

+ (NSFetchRequest<University *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"University"];
}

@dynamic about;
@dynamic acronym;
@dynamic admissionRate;
@dynamic assistLink;
@dynamic averageGPA;
@dynamic establishmentYear;
@dynamic name;
@dynamic rank;
@dynamic url;

@end
