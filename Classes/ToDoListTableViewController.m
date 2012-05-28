//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created by Stanley Tang on 10/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "Task.h"
#import "ToDoListTableCellView.h"


@implementation ToDoListTableViewController

@synthesize managedObjectContext, tblCell, addTaskButton;

- (NSFetchRequest *)createNewFetchRequestForListType:(NSString *)toDoListType {
	//Set up fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
	if ([toDoListType isEqualToString:@"Pending"]) {
		request.predicate = [NSPredicate predicateWithFormat:@"completed = %@", [NSNumber numberWithBool:NO]];
	} else {
		request.predicate = [NSPredicate predicateWithFormat:@"completed = %@", [NSNumber numberWithBool:YES]];
	}
	request.fetchBatchSize = 20;
	return [request autorelease];
}

- initWithManagedObjectContext:(NSManagedObjectContext *)context {
	if (self == [super initWithStyle:UITableViewStylePlain]) {
		self.managedObjectContext = context;
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
																 initWithFetchRequest:[self createNewFetchRequestForListType:@"Pending"]
																 managedObjectContext:self.managedObjectContext
																 sectionNameKeyPath:nil cacheName:nil];
		self.fetchedResultsController = aFetchedResultsController;
		[aFetchedResultsController release];
	
		//Set up keys
		self.titleKey = @"taskName";
	}
	return self;
}

- (IBAction)addTask {
	AddTaskViewController *addTaskVC = [[[AddTaskViewController alloc] init] autorelease];
	addTaskVC.delegate = self;
	addTaskVC.isNew = YES;
	//addTaskVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:addTaskVC animated:YES];
}

- (void)addTaskViewController:(AddTaskViewController *)sender didAddTaskName:(NSString *)taskName andNotes:(NSString *)notes andDateDue:(NSDate *)dateDue{
	if (taskName.length) {
		Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
		task.taskName = taskName;
		task.dateDue = dateDue;
		task.notes = notes;
		if (!notes) task.notes = @"Notes";
		
		NSError *error;
		if (![self.managedObjectContext save:&error]) {
			// Handle the error.
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addTaskViewController:(AddTaskViewController *)sender didEditTask:(Task *)editedTask {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeToDoList:(UISegmentedControl *)segmentedControl {
	//Pending List
	if (segmentedControl.selectedSegmentIndex == 0) {
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
																 initWithFetchRequest:[self createNewFetchRequestForListType:@"Pending"]
																 managedObjectContext:self.managedObjectContext
																 sectionNameKeyPath:nil cacheName:nil];
		self.fetchedResultsController = aFetchedResultsController;
		[aFetchedResultsController release];
	} 
	//Completed List
	else {
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
																 initWithFetchRequest:[self createNewFetchRequestForListType:@"Completed"]
																 managedObjectContext:self.managedObjectContext
																 sectionNameKeyPath:nil cacheName:nil];
		self.fetchedResultsController = aFetchedResultsController;
		[aFetchedResultsController release];
	}
}

- (void)createToolbarItems {
	//Search button
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTask)];
	
	//Segmented control for pending and completed
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Pending", @"Completed", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tintColor = self.navigationController.navigationBar.tintColor;
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(changeToDoList:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *pendingCompleted = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	[segmentedControl release];
	
	//Flex item - to put space between buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, flexItem, pendingCompleted, flexItem, searchButton, nil] animated:YES];
	
	//Release buttons
	[searchButton release];
	[pendingCompleted release];
	[flexItem release];
}

- (void)manageObjectChecked:(NSManagedObject *)object forTableViewCell:(ToDoListTableCellView *)cell {
	[cell toggleCheckbox];
	Task *task = (Task *)object;
	if ([[object valueForKey:@"completed"] isEqual:[NSNumber numberWithBool:YES]]) task.completed = [NSNumber numberWithBool:NO];
	else task.completed = [NSNumber numberWithBool:YES];
}

- (IBAction)checkButtonTapped:(id)sender event:(id)event {
	NSSet *touches = [event allTouches]; 
	UITouch *touch = [touches anyObject]; 
	CGPoint currentTouchPosition = [touch locationInView:self.tableView]; 
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition]; 
	if (indexPath) 
		[self manageObjectChecked:[self.fetchedResultsController objectAtIndexPath:indexPath]
				 forTableViewCell:(ToDoListTableCellView *)[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)createTableBackgroundForTableView:(UITableView *)aTableView {
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableviewbg.png"]];
	aTableView.backgroundView = backgroundView;
	[backgroundView release];
	aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;	
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad {
	[super viewDidLoad];
	[self createToolbarItems];
	[self createTableBackgroundForTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
}


#pragma mark -
#pragma mark CoreDataTableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject
{
	static NSString *ReuseIdentifier = @"CoreDataTableViewCell";
	ReuseIdentifier = @"tblCellView";
	
	ToDoListTableCellView *cell = (ToDoListTableCellView *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ToDoListTableCellView" owner:self options:nil];
		cell = tblCell;
		self.tblCell = nil;
	}
	
	cell.showsReorderControl = YES;
	cell.state = UITableViewCellStateDefaultMask;
	
	if (self.titleKey) [cell setLabelText:[managedObject valueForKey:self.titleKey]];
	if (self.subtitleKey) cell.detailTextLabel.text = [managedObject valueForKey:self.subtitleKey];
	cell.accessoryType = [self accessoryTypeForManagedObject:managedObject];
	UIImage *thumbnail = [self thumbnailImageForManagedObject:managedObject];
	if (thumbnail) cell.imageView.image = thumbnail;
	
	if ([[managedObject valueForKey:@"completed"] isEqual:[NSNumber numberWithBool:YES]]) [cell setCheckboxForState:@"check"];
	else [cell setCheckboxForState:@"uncheck"];
	
	[cell.checkbox addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	
	return cell;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject {
	AddTaskViewController *addTaskVC = [[[AddTaskViewController alloc] initWithExistingTask:(Task*)managedObject] autorelease];
	addTaskVC.delegate = self;
	//addTaskVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:addTaskVC animated:YES];
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	NSManagedObject *aManagedObject = managedObject;
	NSManagedObjectContext *context = [aManagedObject managedObjectContext];
	[context deleteObject:aManagedObject];
	NSError *error = nil;
	if (![context save:&error]) {
		// Handle the error
	}
}

- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject {
	return YES;
}

- (UITableViewCellAccessoryType)accessoryTypeForManagedObject:(NSManagedObject *)managedObject {
	return UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	NSMutableArray *array = [[self.fetchedResultsController fetchedObjects] mutableCopy];
	id objectToMove = [[array objectAtIndex:fromIndexPath.row] retain];
	[array removeObjectAtIndex:fromIndexPath.row];
	[array insertObject:objectToMove atIndex:toIndexPath.row];
	[objectToMove release];
	
	for (int i=0; i<[array count]; i++) {
		[(NSManagedObject *)[array objectAtIndex:i] setValue:[NSNumber numberWithInt:i] forKey:@"displayOrder"];
	}
	[array release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

#pragma mark Search bar methods

- (IBAction)searchTask {
	self.searchKey = @"taskName";
}

- (void)createSearchBar
{
	if (self.searchKey.length) {
		if (self.tableView && !self.tableView.tableHeaderView) {
			UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
			[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
			self.searchDisplayController.searchResultsDelegate = self;
			self.searchDisplayController.searchResultsDataSource = self;
			self.searchDisplayController.delegate = self;
			searchBar.frame = CGRectMake(0, 0, 0, 38);
			self.tableView.tableHeaderView = searchBar;
			[searchBar becomeFirstResponder];
			[self createTableBackgroundForTableView:self.searchDisplayController.searchResultsTableView];
		}
	} else {
		self.tableView.tableHeaderView = nil;
	}
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[super searchDisplayControllerWillEndSearch:controller];
	self.searchKey = nil;
}


#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[super dealloc];
	[addTaskButton release];
	[managedObjectContext release];
}

@end
