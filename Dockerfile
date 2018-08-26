FROM alpine

ENV WORK_PATH='/opt'
WORKDIR ${WORK_PATH}
VOLUME [${WORK_PATH}]

# Common Env
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk --no-cache add \
        build-base unzip gcc g++ cmake curl linux-headers bash \
        git nasm yasm libtool pkgconfig autoconf automake coreutils python3-dev \
        # lcms2-dev libavc1394-dev libc-dev jasper-dev \
        fftw-dev libpng-dev libsndfile-dev xvidcore-dev libbluray-dev \
        zlib-dev opencl-icd-loader-dev opencl-headers \
        boost-filesystem boost-system && \
    pip3 install cython && \
    sed -i 's/ash/bash/g' /etc/passwd && \
    echo "export PYTHONPATH=/usr/local/lib/python3.6/site-packages" >> /etc/profile

ENTRYPOINT ["/bin/bash", "-l"]

# OpenCV
# ENV OPENCV_VERSION=3.4.2
# RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
#   unzip ${OPENCV_VERSION}.zip && \
#   rm -rf ${OPENCV_VERSION}.zip && \
#   mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
#   cd /opt/opencv-${OPENCV_VERSION}/build && \
#   cmake \
#     -D CMAKE_BUILD_TYPE=RELEASE \
#     -D CMAKE_INSTALL_PREFIX=/usr/local \
#     -D WITH_FFMPEG=NO \
#     -D WITH_IPP=NO \
#     -D WITH_OPENEXR=NO \
#     -D WITH_TBB=NO \
#     -D BUILD_EXAMPLES=NO \
#     -D BUILD_ANDROID_EXAMPLES=NO \
#     -D INSTALL_PYTHON_EXAMPLES=NO \
#     -D BUILD_DOCS=NO \
#     -D BUILD_opencv_python2=NO \
#     -D BUILD_opencv_python3=NO \
#   .. && \
#   make -j$(nproc) && make install && \
#   rm -rf /opt/opencv-${OPENCV_VERSION}

# zimg
RUN git clone https://github.com/sekrit-twc/zimg.git && \
    cd zimg && \
    ./autogen.sh && bash -c ./configure && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf zimg

# Vapoursynth
RUN git clone https://github.com/vapoursynth/vapoursynth.git && \
    cd vapoursynth && \
    ./autogen.sh && bash -c ./configure && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf vapoursynth

# Plugins  
RUN git clone https://github.com/darealshinji/vapoursynth-plugins.git && \
    cd vapoursynth-plugins && \
    ./autogen.sh && bash -c ./configure && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf vapoursynth-plugins

# Encoder
RUN apk --no-cache add ffmpeg x264 x265