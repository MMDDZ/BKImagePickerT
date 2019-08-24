Pod::Spec.new do |spec|

  spec.name         = "BKImagePicker"
  spec.version      = "0.0.1"
  spec.summary      = "image library"
  spec.homepage     = "https://github.com/MMDDZ/BKImagePickerT"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.authors      = { "MMDDZ" => "694092596@qq.com" }
  spec.source       = { :git => "http://github.com/MMDDZ/BKImagePickerT.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = ''
  s.public_header_files = ''
  s.private_header_files = ''

  s.framework  = "UIKit"

end
