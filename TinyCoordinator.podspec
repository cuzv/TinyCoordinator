Pod::Spec.new do |s|
  s.name         = "TinyCoordinator"
  s.version      = "0.5.1"
  s.summary      = "The Swift version of ThinningCoordinator focus on lighter view controllers."
  s.homepage     = "https://github.com/cuzv/TinyCoordinator"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Moch Xiao" => "cuzv@qq.com" }
  s.author = { "Moch Xiao" => "cuzval@gmail.com" }
  s.source       = { :git => "https://github.com/cuzv/TinyCoordinator.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.framework  = "UIKit"
  s.platform     = :ios, "8.0"
  s.requires_arc = true
end
