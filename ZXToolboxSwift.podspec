Pod::Spec.new do |s|

  s.name         = "ZXToolboxSwift"
  s.version      = "0.0.1"
  s.summary      = "Development kit for iOS"
  s.description  = <<-DESC
                   Development kit for iOS.
                   DESC
  s.homepage     = "https://github.com/xinyzhao/ZXToolboxSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "xinyzhao" => "xinyzhao@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xinyzhao/ZXToolboxSwift.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.frameworks = "Foundation", "UIKit"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.source_files  = "ZXToolboxSwift/ZXToolboxSwift.swift"

  s.subspec "Foundation" do |ss|
    ss.source_files  = "ZXToolboxSwift/Foundation/*.swift"
  end

  s.subspec "UIKit" do |ss|
    ss.dependency 'ZXToolboxSwift/Foundation'
    ss.source_files  = "ZXToolboxSwift/UIKit/*.swift"
  end

end
