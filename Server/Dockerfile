#FROM k1row/amazonlinux-ja
FROM centos

# Install initail modules
RUN yum update -y
RUN yum -y install gcc gcc-c++ make openssl-devel build-essential curl openssl openssl-devel readline-devel readline compat-readline5 git zlib1g-dev libssl-dev libreadline-dev libyaml-dev ruby-devel svn autoconf bison

RUN yum -y --enablerepo=epel,remi,rpmforge install libxml2 libxml2-devel
RUN yum -y --enablerepo=epel,remi,rpmforge install libxslt libxslt-devel

RUN yum -y install sqlite-devel
RUN yum -y install vim
RUN yum -y install sudo
RUN yum -y install passwd
RUN yum -y install tar
RUN yum -y install python-setuptools

# Install SSH
RUN yum -y install openssh
RUN yum -y install openssh-server
RUN yum -y install openssh-clients
RUN yum -y install mysql-client mysql-devel mysql-shared

#RUN passwd -f -u ec2-user
#ADD ./authorized_keys /home/ec2-user/.ssh/authorized_keys



# Create User
RUN useradd docker
#RUN echo 'docker:dockerpasswd' | chpasswd
RUN yes docker | passwd docker

# Set up SSH
#RUN mkdir -p /home/docker/.ssh
#RUN chown docker /home/docker/.ssh
#RUN chmod 700 /home/docker/.ssh
#ADD authorized_keys /home/docker/.ssh/authorized_keys
#RUN chown docker /home/docker/.ssh/authorized_keys
#RUN chmod 600 /home/docker/.ssh/authorized_keys


RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
#RUN service sshd start
#RUN service sshd stop


# Insatall rbenv, ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN mkdir -p ~/.rbenv/plugins
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN bash -lc 'source .bashrc'

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

RUN bash -lc 'rbenv install 2.1.2'
RUN bash -lc 'rbenv rehash'
RUN bash -lc 'rbenv global 2.1.2'
RUN bash -l -c 'ruby -v'

RUN bash -lc 'gem install bundler'

# clone application form github
RUN mkdir -p /var/www
RUN git clone https://github.com/k1row/AirTrackServer.git /var/www/rails
WORKDIR /var/www/rails

# Set up rails
RUN bash -l -c 'bundle config build.nokogiri --use-system-libraries'
RUN gem install nokogiri -v '1.6.2.1' -- --use-system-libraries --no-rdoc --no-ri
RUN gem install mysql2 -v '0.3.16' --no-rdoc --no-ri

#RUN bash -l -c 'bundle install'
#RUN bash -l -c 'bundle exec rake db:create RAILS_ENV=production; bundle exec rake db:migrate RAILS_ENV=production'
#RUN bash -l -c 'bundle exec rake master:import'
#ADD ./secrets.yml /var/www/rails/config/secrets.yml

# nginx
RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum -y install nginx


# Install MySQL Client
RUN yum -y --enablerepo=remi,epel,rpmforge install mysql-client mysql-devel

# Install supervisord
RUN easy_install supervisor

# supervisord
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN echo '[include]' >> /etc/supervisord.conf
RUN echo 'files = supervisord/conf/*.conf' >> /etc/supervisord.conf
RUN mkdir -p /etc/supervisord/conf/
ADD supervisor.conf /etc/supervisord/conf/service.conf

EXPOSE 22 80 3000
CMD bash -l -c 'bundle exec rails s'

# Run supervisord at startup
CMD ["/usr/bin/supervisord"]
