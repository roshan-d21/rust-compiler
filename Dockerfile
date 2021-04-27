FROM ubuntu:20.04

RUN apt-get update &&\
    apt-get install -y build-essential git flex byacc bison python3.8 &&\
    ln -s /usr/bin/python3.8 /usr/bin/python3 &&\
    mkdir /root/rust-compiler

RUN mkdir /root/rust-compiler
WORKDIR /root/rust-compiler

COPY D* M* R* p* t* .gitignore ./
COPY ./.git/ ./.git/

CMD ["/bin/bash"]