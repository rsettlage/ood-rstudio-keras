## combining the tidyverse and verse Dockerfiles, wanting to make sure I have the rstudio-r version

FROM rsettlag/ood-rstudio-bio:4.0.3

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

# ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/:/miniconda3/bin

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  vim

RUN echo "options(repos = c(CRAN='https://cran.rstudio.com'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN Rscript -e "install.packages('tensorflow');library(tensorflow); \
    install_tensorflow(method='conda');install.packages('keras')"
RUN apt-get clean
RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
RUN echo 'R_ENVIRON=~/.Renviron.OOD \
      \nR_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site
