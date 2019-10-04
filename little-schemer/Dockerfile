FROM rocker/tidyverse:3.6.1

RUN apt update && apt install -y \
    gauche \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

RUN install2.r --error \
    subprocess \
 && rm -rf /tmp/downloaded_packages/

COPY r /tmp/r

RUN Rscript --vanilla -e 'remotes::install_local("/tmp/r/knitscm")' \
 && rm -rf /tmp/r
