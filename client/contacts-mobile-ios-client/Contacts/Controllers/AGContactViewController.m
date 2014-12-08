/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGContactViewController.h"
#import "AGContactsNetworker.h"
#import "AGContact.h"

@interface AGContactViewController ()


@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateLabel;

@end

@implementation AGContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refresh];
}

#pragma mark - AGContactDetailsViewControllerDelegate methods

- (void)contactDetailsViewControllerDidCancel:(AGContactDetailsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactDetailsViewController:(AGContactDetailsViewController *)controller didSave:(AGContact *)contact {
    id completionHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) { // if an error occured
            
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // dismiss modal dialog
            [self dismissViewControllerAnimated:YES completion:nil];
            // refresh table
            [self refresh];
        }
    };
    
    [[AGContactsNetworker shared] PUT:[NSString stringWithFormat:@"/contacts/%@", contact.recId] // append contact id
                           parameters:[contact asDictionary] completionHandler:completionHandler];
}

#pragma mark - Seque methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditContactSegue"]) {
        AGContactDetailsViewController *contactDetailsViewController = [segue.destinationViewController viewControllers][0];
        contactDetailsViewController.contact = self.contact;
        contactDetailsViewController.delegate = self;
    }
}

#pragma mark - Table methods

- (void)refresh {
    [self.nameLabel setTitle:[NSString stringWithFormat:@"%@ %@", self.contact.firstname, self.contact.lastname] forState:UIControlStateNormal];
    self.phoneLabel.text = self.contact.phoneNumber;
    self.emailLabel.text = self.contact.email;
    self.birthdateLabel.text = self.contact.birthdate;
}

@end
