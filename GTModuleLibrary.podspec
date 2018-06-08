Pod::Spec.new do |s|
  s.name         = "GTModuleLibrary"
  s.version      = "0.0.1"
  s.summary      = "A short description of GTModuleLibrary."


  s.homepage     = "http://EXAMPLE/GTModuleLibrary"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "liuxc123" => "lxc_work@126.com" }
  s.source       = { :git => 'https://github.com/liuxc123/GTModuleLibrary.git', :tag => s.version.to_s }

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"

  # 设置默认的模块，如果在pod文件中导入pod项目没有指定子模块，导入的是这里指定的模块
  s.default_subspec = 'GTCore'

  s.requires_arc = true



  # 定义一个核心模块，用户存放抽象的接口、基类以及一些公用的工具类和头文件
  s.subspec 'GTCore' do |subspec|
      # 源代码
      subspec.source_files = 'GTModuleLibrary/GTModuleLibrary/GTBaseModule/GTCore/**/*.*'
      
      # 添加资源文件
      subspec.resources = 'GTModuleLibrary/GTModuleLibrary/GTBaseModule/GTCore/**/*.bundle'

      # subspec.resource_bundles = 'GTModuleLibrary/GTModuleLibrary/GTBaseModule/GTCore/**/*.bundle'
      
      # 配置系统Framework
      subspec.frameworks = 'UIKit', 'Foundation'

      # 依赖其他的pod库
      subspec.dependency 'SDWebImage'
      subspec.dependency 'YTKNetwork'
      subspec.dependency 'RealReachability'
      subspec.dependency 'MBProgressHUD'
      subspec.dependency 'BeeHive'
      subspec.dependency 'JLRoutes'
      subspec.dependency 'Masonry'
      subspec.dependency 'FMDB'

  end

end
