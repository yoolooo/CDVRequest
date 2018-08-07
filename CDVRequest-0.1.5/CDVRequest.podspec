Pod::Spec.new do |s|
  s.name = "CDVRequest"
  s.version = "0.1.5"
  s.summary = "A short description of CDVRequest."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"yoolooo"=>"864275697@qq.com"}
  s.homepage = "https://github.com/yoolooo/CDVRequest"
  s.description = "TODO: Add long description of the pod here."
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/CDVRequest.framework'
end
