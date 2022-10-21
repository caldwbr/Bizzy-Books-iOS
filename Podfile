source 'https://github.com/CocoaPods/Specs.git'


# Uncomment this line to define a global platform for your project
 platform :ios, '12.0'

target 'Bizzy Books' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

    pod 'FirebaseUI', '12.3'
    pod 'FirebaseUI/Auth'
    pod 'FirebaseUI/Email'
    pod 'FirebaseUI/Google'
    pod 'FirebaseUI/Facebook'
    pod 'FirebaseUI/Database'

    pod 'FirebaseCore', '10.0'

    pod 'FirebaseDatabase', '10.0'

    pod 'FirebaseAuth', '10.0'

    pod 'FirebaseStorage', '10.0'

    pod 'GoogleSignIn'

    pod 'FacebookSDK'

    pod 'Fabric'
    
    pod 'RNCryptor', '~> 5.0'
    
    # Dropdown
    pod 'MKDropdownMenu'

    # Centered collection view layout
    pod 'KTCenterFlowLayout'

    pod 'SimplePDF', '3.0'

#    pod 'Charts', '4.1.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
    target.build_configurations.each do |config|
      if target.name == "SimplePDF"
         config.build_settings['SWIFT_VERSION'] = '4.0'
     end
  end
  end
end
