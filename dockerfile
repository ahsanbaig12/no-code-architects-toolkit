# Use base image
FROM ubuntu:20.04

# Avoid interactive timezone prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-dev \
    build-essential meson ninja-build \
    libtool pkg-config nasm yasm && \
    apt-get clean

# Clone and build VMAF
RUN git clone https://github.com/Netflix/vmaf.git && \
    cd vmaf/libvmaf && \
    meson build --buildtype release && \
    ninja -C build && \
    ninja -C build install && \
    ldconfig && \
    cd ../.. && rm -rf vmaf

# Set working directory
WORKDIR /app

# Copy your project files
COPY . /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Expose the port your app runs on
EXPOSE 5000

# Start the server (adjust this to your app entry point)
CMD ["python3", "app.py"]
