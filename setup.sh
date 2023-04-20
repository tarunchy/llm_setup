#!/bin/bash

# Update package lists and install dependencies
sudo dnf update -y
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y zlib-devel libffi-devel openssl-devel bzip2-devel libnss-devel readline-devel wget curl

# Download and install the latest Python version
PYTHON_LATEST=$(curl -s https://www.python.org/ftp/python/ | grep -oP '(?<=href=")[0-9]+\.[0-9]+\.[0-9]+(?=/")' | sort -V | tail -n 1)
wget https://www.python.org/ftp/python/$PYTHON_LATEST/Python-$PYTHON_LATEST.tar.xz
tar -xf Python-$PYTHON_LATEST.tar.xz
cd Python-$PYTHON_LATEST
./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall
cd ..
rm -rf Python-$PYTHON_LATEST.tar.xz Python-$PYTHON_LATEST

# Ensure pip is installed and up to date
python3.x -m ensurepip --default-pip
python3.x -m pip install --upgrade pip

# Install virtualenv
python3.x -m pip install virtualenv

# Create and activate virtual environment
python3.x -m virtualenv myenv
source myenv/bin/activate

# Create a requirements.txt file
cat > requirements.txt << EOL
numpy
pandas
jupyter
tensorflow-gpu
keras
torch
torchvision
accelerate>=0.12.0
transformers[torch]==4.25.1
EOL

# Install deep learning libraries from the requirements.txt file
pip install -r requirements.txt

# Replace `python3.x` with the actual Python version installed (e.g., `python3.10`).
