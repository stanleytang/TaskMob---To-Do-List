//
//  ToDoListTableViewController.h
//  ToDoList
//
//  Created by Stanley Tang on 10/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "AddTaskViewController.h"
#import "ToDoListTableCellView.h"


@interface ToDoListTableViewController : CoreDataTableViewController <AddTaskViewControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	IBOutlet ToDoListTableCellView *tblCell;
	IBOutlet UIView *addTaskButton;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) IBOutlet ToDoListTableCellView *tblCell;
 @property (nonatomic, retain) IBOutlet UIView *addTaskButton;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
