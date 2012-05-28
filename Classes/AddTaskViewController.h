//
//  AddTaskViewController.h
//  ToDoList
//
//  Created by Stanley Tang on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol AddTaskViewControllerDelegate;

@interface AddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	IBOutlet UITextField *taskNameField;
	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UITextView *notesView;
	id <AddTaskViewControllerDelegate> delegate;
	BOOL isNew;
	Task *editTask;
}

@property (retain) IBOutlet UITextField *taskNameField;
@property (retain) IBOutlet UINavigationBar *navigationBar;
@property (retain) IBOutlet UITextView *notesView;
@property BOOL isNew;

@property (assign) id <AddTaskViewControllerDelegate> delegate;

- initWithExistingTask:(Task *)task;
- (IBAction)doneAddingTask;
- (IBAction)cancelTask;

@end

@protocol AddTaskViewControllerDelegate
- (void)addTaskViewController:(AddTaskViewController *)sender didAddTaskName:(NSString *)taskName andNotes:(NSString *)notes andDateDue:(NSDate *)dateDue;
- (void)addTaskViewController:(AddTaskViewController *)sender didEditTask:(Task *)editedTask;
@end