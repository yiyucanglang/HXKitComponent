Pod::Spec.new do |s|
  s.name             = 'HXKitComponent'
  s.version          = '0.0.6'
  s.summary          = '开发常用基础库'

  s.homepage         = 'https://github.com/yiyucanglang'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXKitComponent.git', :tag => s.version.to_s }
  s.static_framework = true
  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'CoreHead', 'HXTuple', 'HXDataController', 'HXEmptyView', 'HXImgtextCombineView'

  s.subspec 'CoreHead' do |ss|
    ss.public_header_files = 'HXKitComponent.h'
    ss.source_files = 'HXKitComponent.h'
  end

  s.subspec 'HXTuple' do |ss|
    ss.public_header_files = 'Tuple/*{h}'
    ss.source_files = 'Tuple/*.{h,m}'
    ss.dependency 'HXKitComponent/CoreHead'
  end
  
  s.subspec 'HXDataController' do |ss|
    ss.public_header_files = 'DataController/*{h}'
    ss.source_files = 'DataController/*.{h,m}'
    ss.dependency 'HXKitComponent/HXTuple'
    ss.dependency 'HXKitComponent/CoreHead'
  end
  
  s.subspec 'HXEmptyView' do |ss|
    ss.public_header_files = 'EmptyView/*{h}'
    ss.source_files = 'EmptyView/*.{h,m}'
    ss.dependency 'Masonry'
    ss.dependency 'HXKitComponent/CoreHead'
    
  end

  s.subspec 'HXImgtextCombineView' do |ss|
    ss.public_header_files = 'HXImgtextCombineView/*{h}'
    ss.source_files = 'HXImgtextCombineView/*.{h,m}'
    ss.dependency 'Masonry'
    ss.dependency 'HXKitComponent/CoreHead'
    
  end

  s.subspec 'HXMethodSwitch' do |ss|
    ss.public_header_files = 'HXMethodSwitch/*{h}'
    ss.source_files = 'HXMethodSwitch/*.{h,m}'
  end
  
  s.subspec 'HXSafeTimer' do |ss|
    ss.public_header_files = 'HXSafeTimer/*{h}'
    ss.source_files = 'HXSafeTimer/*.{h,m}'
  end
  
  s.subspec 'HXCustomNaviBarView' do |ss|
    ss.public_header_files = 'HXCustomNaviBarView/*{h}'
    ss.source_files = 'HXCustomNaviBarView/*.{h,m}'
    ss.dependency 'Masonry'
    ss.dependency 'KVOController'
    ss.dependency 'HXKitComponent/HXImgtextCombineView'
    ss.dependency 'HXKitComponent/HXMethodSwitch'
  end
  
 end
