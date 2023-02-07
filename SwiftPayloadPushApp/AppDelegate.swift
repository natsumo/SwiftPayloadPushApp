//
//  AppDelegate.swift
//  SwiftPayloadPushApp
//
//  Created by ikeda.natsumo on 2023/02/07.
//

import UIKit
import NCMB
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var viewController: ViewController!
    
    var payloadData = "プッシュ通知を受信するとここにペイロード情報が表示されます。"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
               
        // APIキーの設定とSDK初期化
        NCMB.initialize(applicationKey: "YOUR_APPLICATION_KEY", clientKey: "YOUR_CLIENT_KEY")
        
        // APNsにデバイストークンを要求
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if((error) != nil) {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        // MARK: アプリが起動されたときにプッシュ通知の情報（ペイロード）からデータを取得する
        if let payload = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            payloadData = payload.map{(key, value) in "\"\(key)\":\"\(value)\""}.joined(separator: "\n")

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.viewController.viewDidLoad()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //端末情報を扱うNCMBInstallationのインスタンスを作成
        let installation : NCMBInstallation = NCMBInstallation.currentInstallation

        //Device Tokenを設定
        installation.setDeviceTokenFromData(data: deviceToken)

        //端末情報をデータストアに登録
        installation.saveInBackground(callback: { result in
            switch result {
            case .success:
                //端末情報の登録が成功した場合の処理
                print("保存に成功しました")
            case let .failure(error):
                //端末情報の登録が失敗した場合の処理
                print("保存に失敗しました: \(error)")
                return;
            }
        })
    }
    
    // MARK: アプリが起動中にプッシュ通知を受信したとき、プッシュ通知の情報（ペイロード）からデータを取得する
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        payloadData = userInfo.map{(key, value) in "\"\(key)\":\"\(value)\""}.joined(separator: "\n")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController.viewDidLoad()
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

