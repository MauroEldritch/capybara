#Container: Ruby PoC Lab
FROM ruby:2.7-buster
WORKDIR /usr/src/app
COPY Gemfile ./
RUN bundle install
RUN apt update
RUN apt install nano -y
RUN mkdir /root/Desktop
COPY . /usr/src/app/
CMD sleep infinity