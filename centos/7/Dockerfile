# Docker image for the chefdk plugin
#
#     docker build --rm=true -t jmccann/chef-centos6 .

FROM centos:centos7.1.1503
MAINTAINER Jacob McCann <jmccann.git@gmail.com>

RUN yum -y install pygpgme yum-utils

ADD chef_stable.repo /etc/yum.repos.d/chef_stable.repo
RUN yum -y install chef-12.5.1 && yum -y update && yum clean all
