FROM rocker/tidyverse:3.6.2

RUN apt update && apt install -y \
    gauche \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

RUN install2.r --error \
    subprocess

RUN installGithub.r --update=FALSE \
    igjit/knitscm@937c92d \
 && rm -rf /tmp/downloaded_packages/
