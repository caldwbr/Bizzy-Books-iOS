source 'https://github.com/CocoaPods/Specs.git'


# Uncomment this line to define a global platform for your project
 platform :ios, '11.0'

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

    pod 'Freddy'

    pod 'SimplePDF'

    pod 'Charts'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
    if target.name == "gRPC-Swift" || target.name == "SwiftNIO" || target.name == "SwiftNIOConcurrencyHelpers" || target.name == "SwiftNIOExtras" || target.name == "SwiftNIOFoundationCompat" || target.name == "SwiftNIOHPACK" || target.name == "SwiftNIOHTTP1" || target.name == "SwiftNIOHTTP2" || target.name == "SwiftNIOSSL" || target.name == "SwiftNIOTLS" || target.name == "SwiftNIOTransportServices" || target.name == "SwiftProtobuf" || target.name == "_NIODataStructures" || target.name == "SwiftNIOCore" || target.name == "NIOCore" || target.name == "SwiftNIOPosix"
      target.build_configurations.each do |config|
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'NO'
      end
    end
    target.build_configurations.each do |config|
      if target.name == "SwiftAlgorithms"
         config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'NO'
     end
  end
  end
end

