/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <Cordova/CDV.h>
#import "preferences.h"


@interface Preferences () {}
@end

@implementation Preferences

- (void)getValue:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* arguments = [command arguments];
        NSString* key = [arguments objectAtIndex:0];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CDVPluginResult* result;

        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[defaults stringForKey:key]];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }];
}
- (void)setValue:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* arguments = [command arguments];
        NSString *key = [arguments objectAtIndex:0], *value = [arguments objectAtIndex:1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CDVPluginResult* result;

        // make sure that value is not NULL, otherwise buggy behavoir of NSUserDefaults.setObject
        //  1st call "NSUserDefaults.setObject null ..." will work
        //  2nd call "NSUserDefaults.setObject NSString ..." will get stuck in mutex _psynch_mutexwait
        if(![value isKindOfClass:[NSNull class]]) {
            [defaults setObject:value forKey:key];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Value cannot be NULL"];
        }
        
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }];
}

@end
