//
//  NACObjectCache.h
//
//  Created by Nathan Cooper on 2013-11-12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * A caching mechanism for quickly finding objects in SQLite using the remote_id field.
 */
@interface NACObjectCache : NSObject

- (id) initWithContext:(NSManagedObjectContext*) managedObjectContext  withFieldName:(NSString *)fieldName;
- (void) cacheObject:(NSManagedObject*)obj forClass:(NSString *) clazz forKey:(int)remote_id;
- (NSManagedObject*) getObjectForClass:(NSString *) clazz forId: (int)remote_id;
- (void) uncache:(NSManagedObject*)obj forClass:(NSString*)clazz forKey:(int)remote_id;

@end
