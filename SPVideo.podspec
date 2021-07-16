#
# Be sure to run `pod lib lint SPVideo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SPVideo'
  s.version          = '0.1.1'
  s.summary          = 'iOS SDK for Real time Video Chat from Superpro.ai'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This SDK lets developers integrate a ready made video call solution in their iOS apps with zero development/integration of video call libraries."

  s.homepage         = 'https://github.com/aravindhu-gloify/SPVideo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aravindhu-gloify' => 'aravindhu@gloify.com' }
  s.source           = { :git => 'https://github.com/aravindhu-gloify/SPVideo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

#  s.source_files = 'VideoPod/Classes/**/*'
  
    s.swift_version = '5.0'
#    s.source_files = 'VideoPod/Classes/**/*.{swift,storyboard,xib}'
#    s.resources = "VideoPod/Assets/**/*."

#    s.source_files = 'VideoPod/**/*.{h,m,swift,plist}'
    s.resources = 'SPVideo/**/*.{storyboard,xib,xcassets,json,png,mp3}'
    
    s.source_files = "SPVideo/**/*.{h,m,swift,plist}"
    
    s.dependency 'Analytics', '~> 4.1'
    s.dependency 'Firebase/Firestore'
    s.dependency 'Firebase/Crashlytics'
    s.dependency 'HMSVideo', '~> 0.10.0'
    
    s.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC'
      }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'ONLY_ACTIVE_ARCH' => 'YES' }
    
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'ONLY_ACTIVE_ARCH' => 'YES' }
end
