# TODO: Update this when releasing HERM publicly
# This dockerfile is forked from ai2/cuda11.8-cudnn8-dev-ubuntu20.04
# To get the latest id, run `beaker image pull ai2/cuda11.8-cudnn8-dev-ubuntu20.04` and then `docker image list`
FROM gcr.io/ai2-beaker-core/public/cn1bn1sukva2b38lbbsg:latest

RUN apt update && apt install -y openjdk-8-jre-headless

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get -y install git-lfs

WORKDIR /stage/

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN pip install -r requirements.txt
RUN pip install "fschat[model_worker,webui]"
RUN pip install -e .

# TODO: enable these when training code is complete
# COPY eval eval
# COPY ds_configs ds_configs
COPY herm herm
COPY scripts scripts
COPY setup.py setup.py
COPY Makefile Makefile
COPY README.md README.md
RUN pip install -e .
RUN chmod +x scripts/*

# for interactive session
RUN chmod -R 777 /stage/
