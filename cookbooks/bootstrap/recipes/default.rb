# update ubuntu package db
execute "apt-get update" do
  user 'root'
end

execute "chown -R vagrant:vagrant /usr/local" do
  user 'root'
end

# get basic os packages
%w[wget curl git-core build-essential ruby1.9.1 redis-server python-pip fontconfig].each do |pkg|
  package pkg do
    action :install
  end
end

ENV['HOME'] = "/home/vagrant"

# used with bottle to serve the webapp
execute "pip install paste barrister" do
  user 'vagrant'
end

execute "npm install -g coffee-script uglify-js docco" do
  user 'vagrant'
end

# phantomjs
if not File.symlink?("/usr/local/bin/phantomjs")
  remote_file "/usr/local/src/phantomjs-1.5.0.tgz" do
    source "http://phantomjs.googlecode.com/files/phantomjs-1.5.0-linux-x86-dynamic.tar.gz"
    checksum "fbae9534bb8c9d4ec3ac6fdb194f12de75144219"
    mode 0644
  end

  execute "tar --no-same-owner -zxf /usr/local/src/phantomjs-1.5.0.tgz" do
    cwd "/usr/local"
    creates "/usr/local/phantomjs"
  end

  link "/usr/local/bin/phantomjs" do
    to "/usr/local/phantomjs/bin/phantomjs"
  end
end
