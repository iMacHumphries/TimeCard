//
//  RemoveEmployeeViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/15/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "RemoveEmployeeViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface RemoveEmployeeViewController ()

@end

@implementation RemoveEmployeeViewController
@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
     employeeNames = [[NSMutableArray alloc]init];
     employeePins = [[NSMutableArray alloc]init];
     NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        [employeeNames addObject:[info valueForKey:@"name"]];
        
    }
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"PIN: %@", [info valueForKey:@"pin"]);
        [employeePins addObject:[info valueForKey:@"pin"]];
        
    }


   
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    

    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [employeeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
     cell.textLabel.text=[employeeNames objectAtIndex:indexPath.row];
    
    return cell;
}
- (IBAction)editButtonPressed:(id)sender {
    if(tableView.editing){
        [tableView setEditing:NO];
    }
    else {
        [tableView setEditing:YES];
        
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addEmployeeButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"manageAdd" sender:sender];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableview commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self setEditingIndex:indexPath];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Removing %@",[employeeNames objectAtIndex:indexPath.row]] message:[NSString stringWithFormat:@"Are you sure you would like to delete the employee: %@? All time sheets will be lost.", [employeeNames objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove Employee", nil];
        [alert show];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"called row touched");
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //delete actuall employee!
    for (Employees *info in fetchedObjects) {
        
        if ([info.pin isEqualToString:[employeePins objectAtIndex:indexPath.row]] ){
            NSLog(@"found employee touched %@", info.name);
            [self performSegueWithIdentifier:@"detail" sender:info];

        }
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detail"]){

        DetailViewController *detail = [segue destinationViewController];
        detail.currentEmployee=(Employees *)sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
    }
}
 
-(NSString *)getEmployeeNameForIndex:(int)ndex {
    NSString *eName = [employeeNames objectAtIndex:ndex];
    return eName;
}
-(NSString *)getEmployeePinForIndex:(int)ndex {
    NSString *ePin = [employeePins objectAtIndex:ndex];
    return ePin;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Remove Employee"]){
        [self removeEmployeeAtRow:[self getEditingIndex]];
    }
}
-(void)removeEmployeeAtRow:(int)theRow {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //delete actuall employee!
    for (NSManagedObject *info in fetchedObjects) {
        
        if ([[info valueForKey:@"pin"] isEqualToString:[employeePins objectAtIndex:theRow]] && ![[info valueForKey:@"pin"] isEqualToString:[employeePins objectAtIndex:0]] ){
            
            [context deleteObject:info];
            [context save:&error];
            
        }
    }
    NSLog(@"got here!!");
    [employeeNames removeObjectAtIndex:theRow];
    [employeePins removeObjectAtIndex:theRow];
    
    [tableView deleteRowsAtIndexPaths:@[[self getEditingIndexPath]] withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView reloadData];

}
-(void)setEditingIndex:(NSIndexPath *)indexPath{
    editingIndex =indexPath.row;
   editingIndexPath = indexPath;
  }
-(int)getEditingIndex{
    return editingIndex;
}

-(NSIndexPath *)getEditingIndexPath{
    return editingIndexPath;
}

@end
