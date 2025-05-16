Install Gitlab

# link packages download
https://packages.gitlab.com/gitlab/gitlab-ee

# add wget for amd
wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ee/packages/debian/buster/gitlab-ee_14.5.0-ee.0_amd64.deb/download.deb

# add wget for arm (macos)
wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ee/packages/debian/buster/gitlab-ee_14.5.0-ee.0_arm64.deb/download.deb

# dpkg deb file amd
sudo dpkg -i gitlab-ee_14.5.0-ee.0_amd64.deb

# dpkg deb file arm (macos)
apt install -y libatomic1
sudo dpkg -i gitlab-ee_14.5.0-ee.0_arm64.deb

# ubah external_url gitlab.rb
vi /etc/gitlab/gitlab.rb -> ubah external_url='http://<ip_ec2>'

# reconfigure gitlab
gitlab-ctl reconfigure

# start gitlab
gitlab-ctl restart

# install gitlab-runner
curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

apt-get install gitlab-runner
gitlab-runner --version