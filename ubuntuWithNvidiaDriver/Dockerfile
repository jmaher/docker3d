FROM ubuntu
#MAINTAINER github/jmaher

### jmaher: from github/gklingler to run opengl on native hardware
RUN apt-get update
RUN apt-get install -y mesa-utils
RUN apt-get install -y kmod
RUN apt-get install -y module-init-tools

# install nvidia driver
RUN apt-get install -y binutils
ADD NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run
RUN sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module
RUN rm /tmp/NVIDIA-DRIVER.run


# install non-build specific dependencies in a single layer, taken from docker-test, etc.
ADD           system-setup.sh   /tmp/system-setup.sh
RUN           bash /tmp/system-setup.sh


### from ubuntu-1204 dockerfile
RUN useradd -d /home/worker -s /bin/bash -m worker
WORKDIR /home/worker

# Set variable normally configured at login, by the shells parent process, these
# are taken from GNU su manual
ENV           HOME          /home/worker
ENV           SHELL         /bin/bash
ENV           USER          worker
ENV           LOGNAME       worker
ENV           HOSTNAME      taskcluster-worker
ENV           LANG          en_US.UTF-8
ENV           LC_ALL        en_US.UTF-8


#### from desktop-test dockerfile
# Add utilities and configuration
COPY           dot-config                    /home/worker/.config
COPY           dot-pulse                     /home/worker/.pulse
COPY           bin                           /home/worker/bin
# This removes the requirement of a developer to call it with bash
RUN            chmod +x /home/worker/bin/test.sh
# TODO: remove this when buildbot is gone
COPY           buildprops.json               /home/worker/buildprops.json
COPY           tc-vcs-config.yml /etc/taskcluster-vcs.yml

# TODO: remove
ADD            https://raw.githubusercontent.com/taskcluster/buildbot-step/master/buildbot_step /home/worker/bin/buildbot_step
RUN chmod u+x /home/worker/bin/buildbot_step

# TODO: remove
ADD            https://s3-us-west-2.amazonaws.com/test-caching/packages/linux64-stackwalk /usr/local/bin/linux64-minidump_stackwalk
RUN chmod +x /usr/local/bin/linux64-minidump_stackwalk

# allow the worker user to access video devices
RUN usermod -a -G video worker

RUN mkdir Documents; mkdir Pictures; mkdir Music; mkdir Videos; mkdir artifacts

# install a new enough npm, plus tc-vcs and tc-npm-cache
RUN npm install -g npm@^2.0.0 \
 && npm install -g taskcluster-vcs@2.3.12 \
 && npm install -g taskcluster-npm-cache@1.1.14 \
 && rm -rf ~/.npm
ENV PATH $PATH:/home/worker/bin

# Remove once running under 'worker' user.  This is necessary for pulseaudio to start
# XXX: change this back to worker:worker once permissions issues are resolved
#JMAHER: hack! this seems to not be needed with updated nvidia driver?!?
#RUN            chown -R root:root /home/worker


# TODO Re-enable worker when bug 1093833 lands
#USER          worker

# clean up
RUN rm -Rf .cache && mkdir -p .cache

# Disable Ubuntu update prompt
# http://askubuntu.com/questions/515161/ubuntu-12-04-disable-release-notification-of-14-04-in-update-manager
ADD release-upgrades /etc/update-manager/release-upgrades

# Disable tools with on-login popups that interfere with tests; see bug 1240084 and bug 984944.
ADD jockey-gtk.desktop deja-dup-monitor.desktop /etc/xdg/autostart/

# In test.sh we accept START_VNC to start a vnc daemon.
# Exposing this port allows it to work.
EXPOSE 5900

# This helps not forgetting setting DISPLAY=:0 when running
# tests outside of test.sh
ENV DISPLAY :0

# Disable apport (Ubuntu app crash reporter) to avoid stealing focus from test runs
ADD apport /etc/default/apport

# Disable font antialiasing for now to match releng's setup
ADD fonts.conf /home/worker/.fonts.conf

# Set a default command useful for debugging
CMD ["/bin/bash", "--login"]
