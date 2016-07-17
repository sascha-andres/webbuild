# Copyright 2016 Sascha Andres
#   
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM briefbote/webbuild:55
MAINTAINER Sascha Andres <sascha.andres@outlook.com>

RUN echo "\n*** Ruby ***\n" && \
    apt-get install -y ruby ruby-dev libffi-dev make

RUN gem install rubygems-update && \
    update_rubygems && \
    gem install sass --no-document && \
    gem install compass --no-document && \
    gem install breakpoint --no-document && \
    echo "\n*** Cleanup ***\n" && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ONBUILD COPY prebuild.sh /exec/prebuild.sh
ONBUILD COPY postbuild.sh /exec/postbuild.sh

RUN chmod 700 /exec/build.sh

ENTRYPOINT /exec/build.sh
