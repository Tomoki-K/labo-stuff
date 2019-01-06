FROM klee/klee
USER root

ENV ruby_ver="2.6.0"

RUN sudo apt-get update \
 && sudo apt-get install -y vim make libssl-dev libreadline-dev zlib1g-dev

# install rbenv & ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN ~/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
 && echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
RUN exec $SHELL

# install ruby version
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install ${ruby_ver}
RUN rbenv global ${ruby_ver}
RUN rbenv rehash

ADD . .
