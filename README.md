## cx_oracle_docker
This is a simple Dockerfile that installs the latest cx_Oracle over ubuntu:latest.

#### What it does
 * Fetches and installs the latest Oracle instant client.
 * Sets `ORACLE_HOME` environment variable to the right directory
 * Installs Python3
 * Installs cx_Oracle module for Python3
 * Creates a `TNS_ADMIN` directory, copies any local files matching `*.ora` files into that directory, and exports the environment variable. 

#### What's the point?
This image can then serve as a starting point for anything that connects to a database using cx_Oracle.

#### How to build

    docker build -t cx_oracle .

#### How to run
You are not supposed to run this, but rather build new container images from here. Start your next Dockerfile with:

    FROM cx_oracle:latest

and then you can install all the other shait you may need.

Good luck!

