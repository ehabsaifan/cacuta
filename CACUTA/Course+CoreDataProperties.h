//
//  Course+CoreDataProperties.h
//  CACUTA
//
//  Created by Ehab Saifan on 8/7/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import ".Course+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *about;
@property (nullable, nonatomic, copy) NSString *areaName;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *college;
@property (nullable, nonatomic, copy) NSString *department;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *numOfUnits;
@property (nullable, nonatomic, copy) NSString *subArea;
@property (nullable, nonatomic, retain) Area *area;

@end

NS_ASSUME_NONNULL_END
