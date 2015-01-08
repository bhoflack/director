FROM ubuntu:14.10

RUN sudo apt-get -y install software-properties-common
RUN sudo add-apt-repository ppa:avsm/ocaml42+opam12
RUN sudo apt-get -y update
RUN sudo apt-get -y install ocaml ocaml-native-compilers camlp4-extra opam build-essential m4 libbin-prot-camlp4-dev
RUN opam init
RUN opam update
RUN opam install -y yojson core async

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/.opam/system/bin

WORKDIR /director
ENTRYPOINT ./build.sh clean director.native
