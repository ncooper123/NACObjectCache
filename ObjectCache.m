//
//  ObjectCache.m
//  LA Creel
//
//  Created by Nathan Cooper on 2013-11-12.
//  Copyright (c) 2013 LDWF. All rights reserved.
//

#import "ObjectCache.h"

@interface ObjectCache()

@property (strong,nonatomic) NSMutableDictionary *cache;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSString *fieldName;

@end

@implementation ObjectCache

@synthesize cache = _cache;

-(id) initWithContext:(NSManagedObjectContext*) managedObjectContext withFieldName:(NSString *)fieldName {
  self = [super init];
  if (self){
    self.fieldName = fieldName;
    self.cache = [[NSMutableDictionary alloc] init];
    self.managedObjectContext = managedObjectContext;
  }
  return self;
}

/**
 * Manually cache an object.
 */
-(void) cacheObject:(NSManagedObject*)obj forClass:(NSString *) clazz forKey:(int)remote_id {
  NSMutableDictionary *classCache = [self.cache objectForKey:clazz];
  NSString *stringKey = [[NSString alloc] initWithFormat:@"%d", remote_id];
  if (classCache == nil){
    //Create this objectCache for the first time...
    classCache = [[NSMutableDictionary alloc] init];
    [self.cache setObject:classCache forKey:clazz];
  }
  [classCache setObject:obj forKey:stringKey];
}

- (void) uncache:(NSManagedObject*)obj forClass:(NSString*)clazz forKey:(int)remote_id {
  NSMutableDictionary *classCache = [self.cache objectForKey:clazz];
  NSString *stringKey = [[NSString alloc] initWithFormat:@"%d", remote_id];
  if (classCache == nil){
    //Create this objectCache for the first time...
    classCache = [[NSMutableDictionary alloc] init];
    [self.cache setObject:classCache forKey:clazz];
  }
  [classCache removeObjectForKey:stringKey];
}

/**
 * Fetches an object, trying first for the dictionary cache, then by a search.
 */
-(NSManagedObject*) getObjectForClass:(NSString *)clazz forId: (int)remote_id{
  NSMutableDictionary *classCache = [self.cache objectForKey:clazz];
  NSString *stringKey = [[NSString alloc] initWithFormat:@"%d", remote_id];
  if (classCache == nil){
    //Create this objectCache for the first time...
    classCache = [[NSMutableDictionary alloc] init];
    [self.cache setObject:classCache forKey:clazz];
  }
  NSManagedObject *obj = [classCache objectForKey:stringKey];
  if (obj == nil){
    //Find this object for the first time...
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *format = [NSString stringWithFormat:@"%@ == %%@",self.fieldName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, stringKey];    
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:clazz inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil || [fetchedObjects count] == 0){
      //We could not find it.
      obj = nil;
    }
    else{
      //We were able to pull it from the database.
      obj = fetchedObjects[0];
      [classCache setObject:obj forKey:stringKey];
    }
  }
  return obj;
}

@end
