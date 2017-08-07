//
//  University+CoreDataProperties.h
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import ".University+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface University (CoreDataProperties)

+ (NSFetchRequest<University *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *about;
@property (nullable, nonatomic, copy) NSString *acronym;
@property (nonatomic) double admissionRate;
@property (nullable, nonatomic, copy) NSString *assistLink;
@property (nullable, nonatomic, copy) NSString *averageGPA;
@property (nullable, nonatomic, copy) NSString *establishmentYear;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *rank;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
