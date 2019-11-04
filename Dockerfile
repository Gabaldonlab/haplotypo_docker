FROM lepinkainen/ubuntu-python-base

# metadata
LABEL base.image="lepinkainen/ubuntu-python-base"
LABEL version="1"
LABEL software="Haplotypo"
LABEL software.version="0.10"
LABEL description="Haplotypo aims to do read mapping and variant calling on phased genomes, without loosing phasing information. In the end the corrected haplotypes are provided."
LABEL website="https://github.com/Gabaldonlab/haplotypo"
LABEL license="GNU General Public License To-Do"

MAINTAINER Manu Molina (CRG)

ARG SOURCE_DIR=/root/src/haplotypo/dependencies
ARG GATK_VERSION=4.0.12.0dev2

WORKDIR /root/src/
# ---------------------------------------
RUN echo "Installing Git + wget + nano..."
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -y git && \
	apt install -y wget && \
	apt-get install -y unzip && \
	apt-get install -y nano
RUN apt-get install -y build-essential
RUN echo "Git + wget + nano installed"
# ---------------------------------------
RUN git clone https://github.com/Gabaldonlab/haplotypo.git

RUN mkdir -p /root/src/haplotypo/dependencies
RUN mkdir -p /root/src/haplotypo/shared
RUN mkdir -p /root/src/haplotypo/shared/output
RUN chmod 777 /root/src/haplotypo/shared/output

WORKDIR /root/src/haplotypo/dependencies/
# ---------------------------------------
RUN echo "Installing Java 1.8..."
# RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
# RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
# RUN apt-get install -y --force-yes oracle-java8-installer
RUN apt install -y openjdk-8-jdk
# ---------------------------------------
RUN echo "Installing libs..."
RUN apt-get -y install libncurses5-dev libncursesw5-dev && \
	apt-get -y install libbz2-dev && \
	apt-get -y install -y liblzma-dev
RUN echo "Libs installed"
# ---------------------------------------
RUN echo "Installing BWA"
RUN wget https://github.com/lh3/bwa/releases/download/v0.7.15/bwa-0.7.15.tar.bz2
RUN tar -vxjf bwa-0.7.15.tar.bz2
WORKDIR $SOURCE_DIR/bwa-0.7.15
RUN make 
RUN echo "BWA installed"


WORKDIR $SOURCE_DIR
# ---------------------------------------
RUN echo "Installing Samtools, Bcftools and Htslib"
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y libbz2-dev
RUN apt-get install -y bzip2
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libncurses5-dev 
RUN apt-get install -y libncursesw5-dev
RUN apt-get install -y liblzma-dev

RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2
RUN git clone --recursive git://github.com/ekg/vcflib.git

RUN tar -vxjf htslib-1.9.tar.bz2
RUN tar -vxjf samtools-1.9.tar.bz2
RUN tar -vxjf bcftools-1.9.tar.bz2

WORKDIR $SOURCE_DIR/htslib-1.9
RUN make
WORKDIR $SOURCE_DIR/samtools-1.9
RUN make
WORKDIR $SOURCE_DIR/bcftools-1.9
RUN make
WORKDIR $SOURCE_DIR/vcflib
RUN make

ENV PATH "/root/src/haplotypo/dependencies/samtools-1.9/:${PATH}"
ENV PATH "/root/src/haplotypo/dependencies/bcftools-1.9/:${PATH}"
RUN echo "Samtools, Bcftools and Htslib installed"

WORKDIR $SOURCE_DIR
# --------------------------------------- 
RUN echo "Installing GATK"
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.0.12.0/gatk-4.0.12.0.zip
RUN unzip gatk-4.0.12.0.zip
RUN echo "GATK installed"
# ---------------------------------------
RUN echo "Installing freebayes"
RUN git clone --recursive git://github.com/ekg/freebayes.git
WORKDIR $SOURCE_DIR/freebayes
RUN make
RUN make install
RUN echo "freebayes installed"

WORKDIR $SOURCE_DIR
# ---------------------------------------
RUN echo "Installing Python libraries"
RUN pip install pyvcf
RUN pip install biopython
RUN pip install psutil
RUN echo "Python libraries installed"
# ---------------------------------------
# Clean cache
WORKDIR "/root/src/haplotypo"
RUN apt-get clean
RUN set -x; rm -rf /var/lib/apt/lists/*
# ---------------------------------------
