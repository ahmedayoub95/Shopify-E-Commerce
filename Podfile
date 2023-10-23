# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Shahalami.pk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shahalami.pk
  pod "Mobile-Buy-SDK"
  pod 'AKSideMenu'
  pod 'CircleBar'
  pod 'CBFlashyTabBarController'
  pod 'NVActivityIndicatorView'   #https://github.com/ninjaprox/NVActivityIndicatorView
  pod "ViewAnimator"
  pod 'ReachabilitySwift'
  pod 'SwiftGifOrigin' , '~> 1.7.0' #https://github.com/swiftgif/SwiftGif
  pod "CDAlertView"       #https://github.com/candostdagdeviren/CDAlertView
  pod 'EVReflection'
  pod 'IQKeyboardManager', '6.2.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SDWebImage'
  pod "ImageSlideshow"
  pod "ImageSlideshow/SDWebImage"
  pod 'TagListView', '~> 1.0'
  pod 'iOSDropDown'
  pod 'PageMenu'
  pod 'TransitionButton'
  pod 'UIView-Shimmer', '~> 1.0'
  pod 'Alamofire', '4.8.1'
  pod 'MaterialComponents/Snackbar'
  pod 'MDFInternationalization'
  pod 'KeychainSwift'
  pod 'ViewPager-Swift'
  pod "FBSDKLoginKit", '~> 14.1.0'
  pod 'FBSDKCoreKit', '~> 14.1.0'
  pod 'FBSDKShareKit', '~> 14.1.0'
  pod 'Firebase/Core'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'Firebase/Messaging'


  post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
  end
  end

end

