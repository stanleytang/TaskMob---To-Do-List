//
//  Task.h
//  ToDoList
//
//  Created by Stanley Tang on 09/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Task :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * dateDue;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber *displayOrder;

@end


