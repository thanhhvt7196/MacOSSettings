# Uncomment the next line to define a global platform for your project
 platform :osx, '13.0'

target 'FirstMacOSApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FirstMacOSApp
	pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
