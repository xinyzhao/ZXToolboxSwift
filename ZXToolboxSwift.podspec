Pod::Spec.new do |s|

  s.name         = "ZXToolboxSwift"
  s.version      = "0.0.6"
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
  
  s.swift_version = '5.0'

  s.source_files  = "ZXToolboxSwift/**/*.swift"

end
