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

#import "AGValidationTextfield.h"

@implementation AGValidationTextfield

- (void) awakeFromNib {
    [super awakeFromNib];

    [self setup];
}

- (void)setup {
    // subscribe to get notif for textfield events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
}

- (BOOL)validate {
    BOOL isValid =(self.validationStrategy? [self.validationStrategy validate:self.text]: YES);
    self.background = isValid ? [UIImage imageNamed:@"line_green"]: [UIImage imageNamed:@"line_red"];
    
    return isValid;
}

#pragma mark - UITextField notification handling

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    [self resignFirstResponder];
    [self validate];
}

@end
