//
//  Area+CoreDataProperties.h
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import ".Area+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Area (CoreDataProperties)

+ (NSFetchRequest<Area *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *about;
@property (nullable, nonatomic, copy) NSString *minRequierdUnits;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) int32_t numOfSections;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSSet<FavoriteCourse *> *courses;
@property (nullable, nonatomic, retain) NSSet<Course *> *coursesList;

@end

@interface Area (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(FavoriteCourse *)value;
- (void)removeCoursesObject:(FavoriteCourse *)value;
- (void)addCourses:(NSSet<FavoriteCourse *> *)values;
- (void)removeCourses:(NSSet<FavoriteCourse *> *)values;

- (void)addCoursesListObject:(Course *)value;
- (void)removeCoursesListObject:(Course *)value;
- (void)addCoursesList:(NSSet<Course *> *)values;
- (void)removeCoursesList:(NSSet<Course *> *)values;

@end

NS_ASSUME_NONNULL_END
