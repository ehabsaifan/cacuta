//
//  Student+CoreDataProperties.h
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import ".Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *college;
@property (nonatomic) double gpa;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *studentID;
@property (nullable, nonatomic, copy) NSString *targetUniversity;
@property (nullable, nonatomic, retain) NSSet<FavoriteCourse *> *favoriteCourses;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addFavoriteCoursesObject:(FavoriteCourse *)value;
- (void)removeFavoriteCoursesObject:(FavoriteCourse *)value;
- (void)addFavoriteCourses:(NSSet<FavoriteCourse *> *)values;
- (void)removeFavoriteCourses:(NSSet<FavoriteCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
