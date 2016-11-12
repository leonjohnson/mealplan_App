# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'MealPlan' do
    pod 'AFNetworking', '~> 2.0'
    pod 'UnderKeyboard', '~> 4.0'
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'Reachability'
    pod 'RealmSwift' #'~> 2.0.1'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'JSQMessagesViewController'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
