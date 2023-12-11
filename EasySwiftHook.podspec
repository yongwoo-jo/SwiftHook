Pod::Spec.new do |spec|
  spec.name         = "EasySwiftHook"
  spec.version      = "3.4.0"
  spec.summary      = "Hook in Swift and Objective C by iOS runtime and libffi."
  spec.description  = <<-DESC
  A secure, simple, and efficient iOS hook library that dynamically modifies the methods of a specific object or all objects of a class. It supports both Swift and Objective-C and has excellent compatibility with Key-Value Observing (KVO).
  It’s based on iOS runtime and [libffi](https://github.com/libffi/libffi).
                   DESC

  spec.homepage     = "https://github.com/623637646/SwiftHook"
  spec.license      = "MIT"
  spec.author             = { "Yanni Wang 王氩" => "wy19900729@gmail.com" }
  spec.platform     = :ios, "12.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/623637646/SwiftHook.git", :tag => spec.version.to_s }
  spec.source_files  = "SwiftHook/Classes/**/*.{h,m,swift}"
  spec.dependency 'libffi-iOS', '~> 3.4.4-iOS'
end
