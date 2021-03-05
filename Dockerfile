FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y build-essential git flex byacc bison

CMD ["/bin/bash"]