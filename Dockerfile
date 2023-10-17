FROM ros:noetic-perception

ENV ROS_DISTRO noetic

RUN apt-get -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  software-properties-common \
  ros-noetic-realsense2-camera \
  ros-noetic-realsense2-description \
  && \
  apt-get install -y ros-noetic-rgbd-launch && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /home/catkin_ws

COPY realsense2_camera src/realsense2_camera
COPY realsense2_description src/realsense2_description
COPY preset.json /root/preset.json
RUN /ros_entrypoint.sh catkin_make install -DCMAKE_INSTALL_PREFIX="/usr/local/realsense"  -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
    sed -i '$isource "/usr/local/realsense/setup.bash"' /ros_entrypoint.sh && \
    rm -rf /home/catkin_ws

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]