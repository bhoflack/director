# director
Task manager that executes tasks in order with dependencies

## Building
Building is done using docker.

First build the docker container:

    ```docker build -t director .```

Once the container is built we can use it to build the software:

    ```docker run -v `pwd`:/director -t director```

Note that a volume is made that links with the current directory.  The software will be built in the _build directory.

The makefile has 2 targets:

  director.byte Compiles to ocaml bytecode.  This requires ocaml on the pc.
  director.native Compiles to native code.  This should run on any compatible pc.
