#import "startApp.h"
#import <Cordova/CDV.h>

@implementation startApp

- (void)check:(CDVInvokedUrlCommand*)command {
    
    CDVPluginResult* pluginResult = nil;
    
    NSString* scheme = [command.arguments objectAtIndex:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:(true)];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:(false)];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void)start:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult* pluginResult = nil;  // 使用 __block 来修改外部变量
    NSString* scheme = [command.arguments objectAtIndex:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
        NSURL *url = [NSURL URLWithString:scheme];
        if (url) {
            // 异步打开 URL，使用 completionHandler 来处理操作完成后的结果
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:NO];
                }
                // 在回调中返回插件结果
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
            return; // 在异步回调完成之前，退出当前方法，避免提前发送 pluginResult
        }
    }
    
    // 如果无法打开 URL 或 URL 无效，直接返回错误
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:NO];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)go:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult* pluginResult = nil;  // 使用 __block 修饰符确保在回调中修改该变量
    NSString* scheme = [command.arguments objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:scheme];
    
    if (url) {
        // 使用新的 openURL 方法来打开 URL
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:NO];
            }
            
            // 在回调完成后返回插件结果
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        // 如果 URL 无效，直接返回错误
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:NO];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
