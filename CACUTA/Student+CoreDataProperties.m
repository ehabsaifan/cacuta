//
//  Student+CoreDataProperties.m
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic college;
@dynamic gpa;
@dynamic image;
@dynamic name;
@dynamic password;
@dynamic studentID;
@dynamic targetUniversity;
@dynamic favoriteCourses;

@end
