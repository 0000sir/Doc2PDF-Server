FROM ruby:2.3
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && sed -i 's|security.debian.org|mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --force-yes build-essential libpq-dev sqlite3 mysql-client libmysqlclient-dev nodejs yarn
RUN yarn config set registry 'https://registry.npm.taobao.org'
RUN mkdir -p /opt/Doc2PDF
WORKDIR /opt/Doc2PDF
ADD Gemfile /opt/Doc2PDF
ADD Gemfile.lock /opt/Doc2PDF
RUN bundle install
ADD . /opt/Doc2PDF
ENV RAILS_ENV=production
#RUN rake assets:precompile
RUN printenv | sed 's/^\(.*\)$/export \1/g' > /etc/profile.d/rails_env.sh
CMD ["/opt/Doc2PDF/start.sh"]
