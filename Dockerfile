# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
#FROM phusion/passenger-full:<VERSION>
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby20:<VERSION>
#FROM phusion/passenger-ruby21:<VERSION>
#FROM phusion/passenger-ruby22:<VERSION>
#FROM phusion/passenger-ruby23:<VERSION>
#FROM phusion/passenger-ruby24:<VERSION>
FROM phusion/passenger-ruby25:0.9.33
#FROM phusion/passenger-jruby91:<VERSION>
#FROM phusion/passenger-nodejs:<VERSION>
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.0.*.sh
#RUN /pd_build/ruby-2.1.*.sh
#RUN /pd_build/ruby-2.2.*.sh
#RUN /pd_build/ruby-2.3.*.sh
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/jruby-9.1.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update && apt-get install -y tzdata && apt-get install -y nodejs && apt-get install -y yarn && apt-get install -y imagemagick

# ...put your own build intructions here...

RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN mkdir /home/app/webapp
RUN chown app:app /home/app/webapp
#RUN ...commands to place your web app in /home/app/webapp<Paste>
COPY --chown=app:app . /home/app/webapp
WORKDIR /home/app/webapp

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"
RUN gem install bundler
RUN bundle install
RUN rm -f /etc/service/nginx/down

RUN yarn install

RUN rm config/credentials.yml.enc
RUN EDITOR="mate --wait" bundle exec rails credentials:edit

RUN chown -R app:app tmp/cache
RUN chown -R app:app log
RUN chown -R app:app public

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
