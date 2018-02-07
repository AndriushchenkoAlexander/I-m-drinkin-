platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'


def pods
  pod 'GoogleMaps'
  pod 'Alamofire', '~> 4.6.0'
  pod 'ObjectMapper', '~> 3.1.0'
  pod 'CFNotify', '~> 1.0.2'
  pod 'Fabric', '~> 1.7.2'
  pod 'Crashlytics', '~>  3.9.3'
end

target 'I am drinking' do
  use_frameworks!
  pods
  #    pod 'FacebookCore'
  #    pod 'FacebookLogin'
  #    pod 'FacebookShare'
  
end

pods3 = ['ObjectMapper']

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if pods3.include? target.to_s
      version = '3.2'
      
      target.build_configurations.each do |config|
        config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        config.build_settings['SWIFT_VERSION'] = version
      end
    end
  end
end
