FROM ubuntu:latest

RUN useradd --gid users --create-home --password test lf-user

RUN apt update
RUN apt upgrade -y
RUN apt install -y git
RUN apt install -y sudo

WORKDIR /home/lf-user

COPY --chown=lf-user build_test_repos.sh .
COPY --chown=lf-user gather_git_statuses.sh .
RUN chmod +x *.sh


USER lf-user

RUN git config --global user.email "lf-user@local"
RUN git config --global user.name "Less Fancy Linux Prompt Tester"
RUN ./build_test_repos.sh
CMD ./gather_git_statuses.sh

