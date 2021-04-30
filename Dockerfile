FROM ubuntu:20.04

RUN apt-get update &&\
    apt-get install -y build-essential git flex byacc python3.8 &&\
    ln -s /usr/bin/python3.8 /usr/bin/python3 &&\
    mkdir /root/rust-compiler

COPY . /root/rust-compiler

WORKDIR /root/rust-compiler

CMD ["/bin/bash"]