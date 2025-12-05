//  FILE:        SceneDelegate.swift
//  PROJECT:     PlantCareTracker
//  COURSE:      Mobile Application Development 2
//  DATE:        12 - 03 - 2025
//  AUTHORS:     Josh Horsley, Will Lee, Jack Prudnikowicz, Kalina Cathcart 

import UIKit


// CLASS:       AppDelegate
// DESCRIPTION: Main application delegate class that manages the app's lifecycle and handles scene-based lifecycle events.     
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    // FUNCTION:    application
    // PARAMETERS:  application - The singleton app object
    //              launchOptions - Dictionary indicating reason app was launched (may be nil)
    // RETURNS:     Bool - false to prevent app from launching, true otherwise
    // DESCRIPTION: Called when application has finished launching.
    //              Is the override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }


    // FUNCTION:    application
    // PARAMETERS:  application - The singleton app object
    //              connectingSceneSession - The session being created
    //              options - Connection options for the scene
    // RETURNS:     UISceneConfiguration - Configuration for the new scene
    // DESCRIPTION: This function is called when a new scene session is being created. 
    //              Returns the configuration to create the new scene with.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // FUNCTION:    application(_:didDiscardSceneSessions:)
    // PARAMETERS:  application - The singleton app object
    //              sceneSessions - Set of scene sessions that were discarded
    // RETURNS:     void
    // DESCRIPTION: Called when the user discards a scene session. 
    //              It is used to release any resources that were specific to the discarded scenes.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

