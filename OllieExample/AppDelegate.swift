//
//  AppDelegate.swift
//  OllieExample
//
//  Created by Niko on 14.02.15.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var robotHandler: RKRobotLE?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        RKRobotDiscoveryAgentLE.sharedAgent().stopDiscovery()
        RKRobotDiscoveryAgentLE.sharedAgent().disconnectAll()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        func connectToSphero() {
            RKRobotDiscoveryAgentLE.sharedAgent().startDiscovery()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "robotDidChangeState:", name: kRobotDidChangeStateNotification, object: nil)
        }
        connectToSphero()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func robotDidChangeState(note:RKRobotChangedStateNotification) {
        switch note.type {
        case .Online:
            let tmpRobot:RKRobotLE = note.robot as RKRobotLE
            self.robotHandler = tmpRobot

            //on
            robotHandler?.radioLink.setDeveloperMode(true)
            robotHandler?.sendCommand(RKRGBLEDOutputCommand.commandWithRed(1.0, green: 1.0, blue: 0.0) as RKDeviceCommand)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {

                //yellow
                self.robotHandler?.sendCommand(RKRGBLEDOutputCommand.commandWithRed(1.0, green: 1.0, blue: 0.0) as RKDeviceCommand)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {

                    //green
                    self.robotHandler?.sendCommand(RKRGBLEDOutputCommand.commandWithRed(0.0, green: 1.0, blue: 0.0) as RKDeviceCommand)
                    self.robotHandler?.sendCommand(RKRollCommand.commandWithHeading(0.0, andVelocity: 0.1) as RKDeviceCommand)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {

                        self.robotHandler?.sendCommand(RKRollCommand.commandWithHeading(90.0, andVelocity: 0.1) as RKDeviceCommand)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                            self.robotHandler?.sendCommand(RKRollCommand.commandWithHeading(180.0, andVelocity: 0.1) as RKDeviceCommand)
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                                self.robotHandler?.sendCommand(RKRollCommand.commandWithHeading(270.0, andVelocity: 0.1) as RKDeviceCommand)
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                                    self.robotHandler?.sendCommand(RKRollCommand.commandWithHeading(0.0, andVelocity: 0.1) as RKDeviceCommand)

                                    //off
                                    self.robotHandler?.sendCommand(RKRollCommand.commandWithStopAtHeading(0) as RKDeviceCommand)
                                    self.robotHandler?.radioLink.setDeveloperMode(false)
                                    self.robotHandler?.sendCommand(RKGoToSleepCommand())
                                }
                            }
                        }
                    }
                }
            }
        case .Disconnected:
            RKRobotDiscoveryAgentLE.sharedAgent().startDiscovery()
            robotHandler = nil
        default:
            println(note.type)
        }
    }

}

