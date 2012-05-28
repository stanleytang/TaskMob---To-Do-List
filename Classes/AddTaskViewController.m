//
//  AddTaskViewController.m
//  ToDoList
//
//  Created by Stanley Tang on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTaskViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation AddTaskViewController

@synthesize taskNameField, navigationBar, notesView, isNew;
@synthesize delegate;

- initWithExistingTask:(Task *)task {
	if (self == [super init]) {
		self.isNew = NO;
		editTask = task;
	}
	return self;
}

- (IBAction)doneAddingTask {
	if (self.isNew) {
		[self.delegate addTaskViewController:self 
						  didAddTaskName:self.taskNameField.text 
								andNotes:self.notesView.text
								 andDateDue:nil];
	} else {
		editTask.taskName = self.taskNameField.text;
		editTask.notes = self.notesView.text;
		[self.delegate addTaskViewController:self didEditTask:editTask];
	}
}

- (IBAction)cancelTask {
	[self.delegate addTaskViewController:self didAddTaskName:nil andNotes:nil andDateDue:nil];
}



#pragma mark -
#pragma mark UIViewController methods

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (editTask) {
		self.notesView.text = editTask.notes;
		if (![self.notesView.text isEqualToString:@"Notes"]) self.notesView.textColor = [UIColor blackColor];
	}
	[self.taskNameField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.taskNameField.text = editTask.taskName;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (!isNew) self.navigationBar.topItem.title = @"Edit Task";
	self.navigationBar.tintColor = UIColorFromRGB(0x305170);
	self.taskNameField.delegate = self;
	self.notesView.delegate = self;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self doneAddingTask];
	return YES;
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldReturn:(UITextView *)textView {
	[textView resignFirstResponder];
	[self doneAddingTask];
	return YES;
}

//Fake placeholder

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"Notes"]) {
        self.notesView.text = @"";
        self.notesView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if([textView.text isEqualToString:@""]) {
        self.notesView.text = @"Notes";
        self.notesView.textColor = [UIColor grayColor];
    }
}


#pragma mark -
#pragma mark Memory stuff

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.taskNameField = nil;
	self.navigationBar = nil;
	self.notesView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[notesView release];
	[taskNameField release];
	[navigationBar release];
}


@end
