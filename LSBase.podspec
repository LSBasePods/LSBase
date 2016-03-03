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

  s.source_files = '*.h'

  s.subspec 'header' do |ss|
    ss.source_files = 'header/*.{h,m}'
  end

  s.subspec 'LSFoundation' do |ss|
    ss.source_files = 'LSFoundation/*.{h,m}'
  end

  s.subspec 'LSUIKit' do |ss|
    ss.source_files = 'LSUIKit/*.{h,m}'
  end

  s.subspec 'LSModel' do |ss|
    ss.source_files = 'LSModel/*.{h,m}'
  end

  s.subspec 'LSUtility' do |ss|
    ss.source_files = 'LSUtility/*.{h,m}'
  end

  s.ios.weak_framework = 'CoreSpotlight','MobileCoreServices'

end
