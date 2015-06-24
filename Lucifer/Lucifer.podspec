
Pod::Spec.new do |s|


  s.name         = "Lucifer"
  s.version      = "0.0.1"
  s.summary      = "A short description of Lucifer."
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'

  s.homepage     = "https://github.com/wallstreetcn/Lucifer"

  s.license      = "LICENSE"
  
  s.author             = "xutengfei"

  s.source       = { :git => "git@github.com:wallstreetcn/Lucifer.git", :tag => "0.0.1" }

  s.source_files  = "Lucifer", "Lucifer/**/*.{h,m}"
  s.exclude_files = "Lucifer/LuciferTests"

  s.requires_arc = true
 
  #arc_files = 'DTFramework/Service/DTService.{h,m}',
  #    'DTFramework/ThirdParty/SDWebImage/**/*.{h,m}',
  #    'DTFramework/BaseInfo/*.{h,m}',
  #    'DTFramework/UI/Waterflow/*.{h,m}'
     
  #s.subspec 'ARC' do |cs|
  #  cs.source_files = arc_files
  #  cs.requires_arc = true
  #end

  #s.subspec 'NARC' do |bs|
  #  bs.source_files = "DTFramework/**/*.{h,m}"
  #  bs.exclude_files = arc_files
  #  bs.requires_arc = false
  #end

  #s.library = 'xml2', 'z', 'icucore'
  #s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  s.prefix_header_file = 'Lucifer/Lucifer/Lucifer-Prefix.pch'

  #s.ios.frameworks = 'QuartzCore', 'AssetsLibrary', 'MapKit', 'ImageIO', 'CoreGraphics', 'MobileCoreServices', 'SystemConfiguration', 'UIKit', 'Foundation', 'CFNetwork', 'CoreLocation'
  #s.dependency 'Samwise/ARC'
  #s.dependency 'Samwise/NARC'
  #s.dependency 'MBProgressHUD', '~> 0.7'
  #s.dependency 'Reachability', '~> 3.1.1'
  #s.dependency 'UMeng', '~> 2.2.0'
  #s.dependency 'libwebp', '~> 0.4.0'

end
