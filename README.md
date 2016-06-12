The files in this repository show how to build and run Docker images/containers with hardware graphics support --> OpenGL + direct rendering (DRI)

For explanations visit: http://gernotklingler.com/blog/howto-get-hardware-accelerated-opengl-support-docker/

-----------------
I have added many tools and configs.

The system-setup.sh comes from:
https://dxr.mozilla.org/mozilla-central/source/testing/docker/ubuntu1204-test

The other files including many of the Dockerfile edits come from:
https://dxr.mozilla.org/mozilla-central/source/testing/docker/desktop-test

I did many tweaks and modifications to make this work.  One difference is that I am running Ubuntu 14.04 vs Ubuntu 12.04 in the docker image.  
