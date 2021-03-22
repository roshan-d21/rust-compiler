FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y build-essential git flex byacc bison

RUN mkdir /root/rust-compiler
WORKDIR /root/rust-compiler

COPY D* M* R* p* t* .gitignore ./
COPY ./.git/ ./.git/

CMD ["/bin/bash"]