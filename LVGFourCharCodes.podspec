Pod::Spec.new do |s|

  s.name         = "LVGFourCharCodes"
  s.version      = "0.0.1"
  s.summary      = "Convert a four-byte integer type to a four-char string."
  s.homepage     = 'https://github.com/letvargo/'
  s.description  = <<-DESC
This framework is used to convert four-byte integer types like OSStatus, UInt32, Int32, etc., to the four-character string. It is useful in debugging functions that return OSStatus error codes, or getting the four-character description of a property that is defined by a constant.
                   DESC
  s.license      = 'MIT'
  s.author             = { "Aaron Rasmussen" => "letvargo@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/letvargo/LVGFourCharCodes.git", :tag => "0.0.1" }
  s.source_files  = "Source/**/*"
  s.requires_arc = true

end