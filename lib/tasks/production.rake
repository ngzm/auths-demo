namespace :production do
  SERVER_DISTDIR = './production/app/auths-demo/'.freeze

  # 製品版環境をリリースする
  desc 'Release all production modules'
  task all: %i[export] do
    puts '--- release all production modules finished ---'
  end

  # production 配下に製品版実行環境一式をエクスポートする
  directory SERVER_DISTDIR
  desc 'Export modules to production'
  task export: [:clean, SERVER_DISTDIR] do
    puts '--- export ---'
    src_path = './'
    exclude_dirs = ['.', '..', '.DS_Store', '.bundle', '.git', '.gitignore', \
                    'client', 'log', 'memo', 'production', 'test', 'tmp', 'vendor']
    Dir.entries(src_path).each do |f|
      next if exclude_dirs.include?(f)
      src = src_path + f
      puts "src = #{src}"
      FileUtils.cp_r src, SERVER_DISTDIR
    end
    puts '--- export finished ---'
  end

  # production 配下の製品版サーバモジュールを全部消去する
  desc 'Clean modules under production'
  task :clean do
    puts '--- clean ---'
    FileUtils.rm_r(SERVER_DISTDIR) if FileTest.exist?(SERVER_DISTDIR)
    puts '--- clean finished ---'
  end
end
