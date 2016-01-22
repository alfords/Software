#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# change Home directory
export HOME=/mnt/home


# source script specifying environment variables
source ~/.EnvVars


# change directory to Temp folder to install NVIDIA driver & CUDA toolkit
cd $TMP_DIR


# install NVIDIA driver
# (ref: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using_cluster_computing.html#install-nvidia-driver)
# G2 Instances
# Product Type: GRID
# Product Series: GRID Series
# Product: GRID K520
# Operating System: Linux 64-bit
# Recommended/Beta: Recommended/Certified
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/358.16/NVIDIA-Linux-x86_64-358.16.run
set +e
sudo sh NVIDIA-Linux-x86_64-358.16.run --silent --kernel-source-path $KERNEL_SOURCE_PATH --tmpdir $TMP_DIR
set -e
echo `df -h /` NVIDIA >> $MAIN_DISK_USAGE_LOG


# install CUDA toolkit
wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
sudo sh cuda_7.5.18_linux.run --silent --driver --toolkit --toolkitpath $CUDA_ROOT --extract $TMP_DIR --kernel-source-path $KERNEL_SOURCE_PATH --tmpdir $TMP_DIR
sudo sh cuda-linux64-rel-7.5.18-19867135.run --noprompt --prefix $CUDA_ROOT --tmpdir $TMP_DIR

# add CUDA executables & libraries to Path
# instructions: Please make sure that
# -   PATH includes /mnt/cuda-7.5/bin
# -   LD_LIBRARY_PATH includes /mnt/cuda-7.5/lib64, or,
# add /mnt/cuda-7.5/lib64 to /etc/ld.so.conf and run ldconfig as root
echo "$CUDA_ROOT/lib64" > cuda.conf
echo "$CUDA_ROOT/lib"  >> cuda.conf
sudo mv cuda.conf /etc/ld.so.conf.d/
sudo ldconfig

# create symbolic links for NVCC
sudo ln -s $CUDA_ROOT/bin/nvcc /usr/bin/nvcc

# copy link stubs (?) to /usr/bin directory
sudo cp -r $CUDA_ROOT/bin/crt/ /usr/bin/

echo `df -h /` CUDA Toolkit >> $MAIN_DISK_USAGE_LOG


# change directory to Programs directory
cd $APPS_DIR


# install OpenBLAS
git clone https://github.com/xianyi/OpenBLAS $OPENBLAS_DIR
cd $OPENBLAS_DIR
make
sudo make install PREFIX=$OPENBLAS_DIR
echo `df -h /` OpenBLAS >> $MAIN_DISK_USAGE_LOG
cd $APPS_DIR

# skip installation of GotoBLAS2 because of error: https://gist.github.com/certik/1224558
# cd $APPS_DIR
# wget https://www.tacc.utexas.edu/documents/1084364/1087496/GotoBLAS2-1.13.tar.gz
# tar xzf GotoBLAS2-1.13.tar.gz
# sudo rm GotoBLAS2-1.13.tar.gz
# cd GotoBLAS2
# make
# sudo make install PREFIX=$GOTOBLAS_DIR
# cd ..
# sudo rm -r GotoBLAS2


# install CUDA-related packages
git clone --recursive http://git.tiker.net/trees/pycuda.git
cd pycuda
sudo python configure.py --cuda-root=$CUDA_ROOT
set +e
sudo make install
set -e
cd ..
sudo rm -r pycuda
echo `df -h /` PyCUDA >> $MAIN_DISK_USAGE_LOG

# sudo pip install git+https://github.com/cudamat/cudamat.git   installation fails

set +e
sudo pip install --upgrade SciKit-CUDA
set -e
echo `df -h /` SciKit-CUDA >> $MAIN_DISK_USAGE_LOG

sudo pip install GNumPy
echo `df -h /` GNumPy >> $MAIN_DISK_USAGE_LOG


# install Theano
sudo pip install --upgrade Theano
echo `df -h /` Theano >> $MAIN_DISK_USAGE_LOG

# download .TheanoRC into new Home directory
cd ~
wget $GITHUB_REPO_RAW_PATH/.config/$THEANORC_SCRIPT_NAME
dos2unix $THEANORC_SCRIPT_NAME
cd $APPS_DIR


# install Deep Learning packages
sudo pip install --upgrade git+git://github.com/mila-udem/fuel.git
echo `df -h /` Fuel >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/mila-udem/blocks.git
echo `df -h /` Blocks >> $MAIN_DISK_USAGE_LOG

set +e
sudo pip install --upgrade Brainstorm[all]
set -e
echo `df -h /` Brainstorm >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade Chainer
echo `df -h /` Chainer >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/akrizhevsky/cuda-convnet2

# sudo pip install --upgrade DeepCL   SKIPPED: needs OpenCL

sudo pip install --upgrade DeepDish
echo `df -h /` DeepDish >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade git+git://github.com/dirkneumann/deepdist.git   SKIPPED: abandoned project
# echo `df -h /` DeepDist >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/andersbll/cudarray
cd cudarray
make
sudo make install
sudo python setup.py install
cd ..
sudo rm -r cudarray
echo `df -h /` CUDArray >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/andersbll/deeppy.git
echo `df -h /` DeepPy >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade Deepy
echo `df -h /` Deepy >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/libfann/fann.git
cd fann
cmake .
sudo make install
cd ..
sudo rm -r fann
sudo pip install --upgrade FANN2
echo `df -h /` FANN2 >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade FFnet
echo `df -h /` FFnet >> $MAIN_DISK_USAGE_LOG

set +e
sudo pip install --upgrade Hebel
set -e
echo `df -h /` Hebel >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade Keras
echo `df -h /` Keras >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip
echo `df -h /` Lasagne >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade Mang   SKIPPED: abandoned project
# echo `df -h /` Mang >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/dmlc/minerva
cd minerva
sudo cp configure.in.example configure.in
# then we need to manually edit CONFIGURE.IN and run below steps
# ./build.sh
cd $APPS_DIR

sudo pip install --upgrade git+git://github.com/hycis/Mozi.git
echo `df -h /` Mozi >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade NervanaNEON
echo `df -h /` NervanaNEON >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade NeuralPy   skip because this downgrades NumPy
# echo `df -h /` NeuralPy >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade NeuroLab
echo `df -h /` NeuroLab >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade NLPnet
echo `df -h /` NLPnet >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade git+git://github.com/zomux/nlpy.git   installation fails
# echo `df -h /` NLPy >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade NN   SKIPPED: toy project
# echo `df -h /` NN >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade NoLearn
echo `df -h /` NoLearn >> $MAIN_DISK_USAGE_LOG

wget http://bitbucket.org/eigen/eigen/get/3.2.7.zip
unzip 3.2.7.zip
sudo rm 3.2.7.zip
mkdir eigen-build
cd eigen-build
cmake $APPS_DIR/eigen-eigen-b30b87236a1b
sudo make install
cd $APPS_DIR
sudo rm -r eigen*
echo `df -h /` Eigen >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/OpenANN/OpenANN.git
cd OpenANN
mkdir build
cd build
cmake ..
sudo make install
sudo ldconfig
cd $APPS_DIR
sudo rm -r OpenANN
sudo mv /usr/local/local/lib64/python2.7/site-packages/* /usr/local/lib64/python2.7/site-packages/
echo `df -h /` OpenANN >> $MAIN_DISK_USAGE_LOG

# git clone https://github.com/guoding83128/OpenDL   SKIPPED: abandoned project
# echo `df -h /` OpenDL >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/vitruvianscience/opendeep.git
cd opendeep
sudo python setup.py develop
cd ..

sudo pip install --upgrade PyBrain
echo `df -h /` PyBrain >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PyBrain2
echo `df -h /` PyBrain2 >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PyDeepLearning
echo `df -h /` PyDeepLearning >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PyDNN
echo `df -h /` PyDNN >> $MAIN_DISK_USAGE_LOG

git clone git://github.com/lisa-lab/pylearn2.git
cd pylearn2
sudo python setup.py develop
cd ..

sudo pip install --upgrade PythonBrain
echo `df -h /` PythonBrain >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade SciKit-NeuralNetwork
echo `df -h /` SciKit-NeuralNetwork >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/sklearn-theano/sklearn-theano
echo `df -h /` SKLearn-Theano >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/dougefr/synapyse.git
echo `df -h /` Synapyse >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.6.0-cp27-none-linux_x86_64.whl
echo `df -h /` TensorFlow >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/google/skflow.git
echo `df -h /` SKFlow >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade Theanets
echo `df -h /` Theanets >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade git+git://github.com/Samsung/veles.git
echo `df -h /` Veles >> $MAIN_DISK_USAGE_LOG

git clone https://github.com/Samsung/veles.znicz
echo `df -h /` Veles.znicz >> $MAIN_DISK_USAGE_LOG
