FROM centos:centos7

ENV RUBY_VERSION 2.7.1
ENV APP_NAME sample_app
ENV LANG C.UTF-8
ENV APP_PATH /usr/src/${APP_NAME}
# rbenvのpathを通す
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# rubyに必要なパッケージをインストール
RUN yum -y update
RUN yum -y install \
  gcc \
  gcc-c++ \
  make \
  glibc-langpack-ja \
  readline \
  readline-devel \
  tar \
  bzip2 \
  openssl-devel \
  zlib-devel

# 便利パッケージをインストール
RUN yum -y install \
  git \
  curl \
  vim \
  sudo \
  unzip

# yarnとnodejsをインストール
# ↓ 参照: https://classic.yarnpkg.com/en/docs/install/#centos-stable
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
# ↓ 参照: https://github.com/nodesource/distributions#installation-instructions-1
RUN curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
RUN yum -y install nodejs yarn
RUN yum clean all

# このプロジェクトに必要な他のパッケージをインストール
RUN yum -y install \
  postgresql \
  postgresql-devel

# rbenvとruby-buildインストール
RUN git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT}
RUN git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

# rbenvを速くするために動的なbash拡張をコンパイルする
RUN ${RBENV_ROOT}/src/configure
RUN make -C ${RBENV_ROOT}/src

# rbenvの確認
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# rubyインストール
RUN rbenv install ${RUBY_VERSION}
RUN rbenv rehash
RUN rbenv global ${RUBY_VERSION}

# bundlerをインストール
RUN gem install bundler

# アプリケーションソースコードのルートディレクトリへ移動
WORKDIR ${APP_PATH}

# entrypointのための処理
COPY script/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# bundle install
#COPY Gemfile* $APP_PATH/
#RUN bundle install
#RUN rbenv rehash

EXPOSE 3000

RUN \
 useradd -m dev; \
 echo 'dev:dev' | chpasswd; \
 echo "dev ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R dev:dev /home/dev
USER dev