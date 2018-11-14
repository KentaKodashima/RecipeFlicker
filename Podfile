# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'RecipeFlicker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RecipeFlicker
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'RealmSwift', '~> 3.1'
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON', '~> 4.2'
  pod 'Koloda', '~> 4.5'
  pod 'Kingfisher', '~> 4.0'
  
  target 'RecipeFlickerTests' do
    # Pods for testing
    pod 'Firebase/Core'
    pod 'Alamofire', '~> 4.7'
  end
  
  target 'RecipeFlickerUITests' do
    # Pods for testing
    pod 'Firebase/Core'
    pod 'Alamofire', '~> 4.7'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # This works around a unit test issue introduced in Xcode 10.
      # We only apply it to the Debug configuration to avoid bloating the app size
      if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
      end
    end
  end
end
