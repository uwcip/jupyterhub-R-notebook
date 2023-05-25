FROM ghcr.io/uwcip/jupyterhub-base-notebook:v1.8.5

# github metadata
LABEL org.opencontainers.image.source=https://github.com/uwcip/jupyterhub-R-notebook

USER root

# install updates and dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# install R and some libraries
RUN conda install --quiet --yes \
    "r-base"  \
    "r-caret" \
    "r-crayon" \
    "r-devtools" \
    "r-e1071" \
    "r-forecast" \
    "r-hexbin" \
    "r-htmltools" \
    "r-htmlwidgets" \
    "r-irkernel" \
    "r-randomforest" \
    "r-rcurl" \
    "r-rmarkdown" \
    "r-rodbc" \
    "r-rsqlite" \
    "r-shiny" \
    "r-tidymodels" \
    "r-tidyverse" \
    "unixodbc" \
    "r-statnet" \
    "rpy2" \
    "r-stm" \
    "r-rpostgres" \
    "r-igraph" \
    "r-rgexf" \
    "r-cowplot" \
    "r-webshot" \
    "r-arrow" \
    && conda clean --all -f -y \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}" \
    && true

# install signnet which does not have a conda package at the moment.
WORKDIR /tmp
RUN wget --quiet "https://cran.r-project.org/src/contrib/signnet_1.0.1.tar.gz" && \
    R CMD INSTALL signnet_1.0.1.tar.gz && \
    rm -rf signnet_1.0.1.tar.gz && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# ensure that we run the container as the notebook user
USER ${NB_UID}
WORKDIR ${HOME}

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
