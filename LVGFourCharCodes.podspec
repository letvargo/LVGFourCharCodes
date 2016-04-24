Pod::Spec.new do |s|

  s.name         = "LVGFourCharCodes"
  s.version      = "0.1.0"
  s.summary      = "Tools for working with OSStatus and other 4-byte types that can be represented by a 'FourCharCode'."
  s.homepage     = 'https://github.com/letvargo/LVGFourCharCodes'
  s.description  = <<-DESC
This framework is used to convert four-byte integer types like OSStatus, UInt32, Int32, etc., to the four-character string. It is useful in debugging functions that return OSStatus error codes, or getting the four-character description of a property that is defined by a constant. It also extends String to add a property called `code` that will convert a four-character String to a `UInt32`.
                   DESC
  s.license      = 'MIT'
  s.author             = { "Aaron Rasmussen" => "letvargo@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.framework = 'Foundation'
  s.source       = { :git => "https://github.com/letvargo/LVGFourCharCodes.git", :tag => "0.1.0" }
  s.source_files  = "Source/**/*"
  s.requires_arc = true

end
