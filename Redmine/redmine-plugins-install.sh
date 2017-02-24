#!/bin/bash
#
# Author: Serge.Focus<Serge.Focus@gmail.com>
# Gist: https://gist.github.com/sergefocus/..
# Short Url (raw): http://goo.gl/..
#
# Installs a bunch of plugins for the docker-redmine image
#
# Usage:
mkdir -p /srv/docker/redmine/redmine 
#/home/redmine/data
cd /srv/docker/redmine/redmine
#   $ wget http://goo.gl/iJcvCP -O - | sh
#
#
## Install tarballs
#

# redmine code review plugin
# HOMEPAGE: https://bitbucket.org/haru_iida/redmine_code_review
# HOMEPAGE: https://github.com/alexandermeindl/redmine_code_review
REDMINE_CODE_REVIEW_VERSION=0.8.0
#0.7.0
rm -rf redmine_code_review
mkdir -p redmine_code_review
wget -nv https://github.com/alexandermeindl/redmine_code_review/archive/${REDMINE_CODE_REVIEW_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_code_review
#wget -nv https://bitbucket.org/haru_iida/redmine_code_review/get/${REDMINE_CODE_REVIEW_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_code_review

rake redmine:plugins:migrate RAILS_ENV=production

# redmine agile plugin
# HOMEPAGE: http://redminecrm.com/projects/agile/pages/1
REDMINE_AGILE_VERSION=v1.4.2
rm -rf redmine_agile
mkdir -p redmine_agile
wget -nv https://github.com/RCRM/redmine_agile/archive/${REDMINE_AGILE_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_agile

# checklists plugin
# HOMEPAGE: https://github.com/RCRM/redmine_checklists
REDMINE_CHECKLISTS_VERSION=v3.1.5
rm -rf redmine_checklists
mkdir -p redmine_checklists
wget -nv https://github.com/RCRM/redmine_checklists/archive/${REDMINE_CHECKLISTS_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_checklists

# https://github.com/VoronyukM/redmine_helpdesk    from.zip

# tweaks plugin
# HOMEPAGE: https://github.com/alphanodes/redmine_tweaks
REDMINE_TWEAKS_VERSION=0.5.8
rm -rf redmine_tweaks
mkdir -p redmine_tweaks
wget -nv https://github.com/AlphaNodes/redmine_tweaks/archive/${REDMINE_TWEAKS_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_tweaks


# twegit_hostingaks plugin
# HOMEPAGE: https://github.com/jbox-web/redmine_git_hosting
REDMINE_GIT_HOSTING_VERSION=1.2.2
rm -rf redmine_git_hosting
mkdir -p redmine_git_hosting
wget -nv https://github.com/jbox-web/redmine_git_hosting/archive/${REDMINE_GIT_HOSTING_VERSION}.tar.gz -O - | tar -zvxf - --strip=1 -C redmine_git_hosting


