git_source = "git@gitlab.corp.21cake.com:iOS_Pods/LSBase.git"

Pod::Spec.new do |s|

  s.name         = "LSBase"
  s.version      = "0.0.1"
  s.summary      = "A short description of LSBase."

  s.homepage     = git_source

  s.license      = "MIT"

  s.author       = { "Terry Zhang" => "zhangqingyu@gmail.com" }
  
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source       = { :git => git_source }

  s.source_files = '*/*.{h,m}','*.h'


end
