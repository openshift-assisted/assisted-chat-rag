FROM registry.access.redhat.com/ubi9/python-312:9.7-1770323761 AS builder

USER 0

RUN dnf install -y \
        git \
        git-lfs \
        make \
        gcc \
        python3-devel \
        mesa-libGL \
        && dnf clean all

RUN pip install uv

WORKDIR /app

COPY . .

RUN make build-db

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

COPY --from=builder /app/all-mpnet-base-v2/ /all-mpnet-base-v2/
COPY --from=builder /app/llama_stack_vector_db/ /llama_stack_vector_db/ 

# this directory is checked by ecosystem-cert-preflight-checks task in Konflux
RUN mkdir /licenses
COPY LICENSE /licenses/

# Labels for enterprise contract
LABEL com.redhat.component=assisted-installer-chat-rag-content
LABEL description="Red Hat OpenShift Assisted Installer Chat RAG content"
LABEL distribution-scope=private
LABEL io.k8s.description="Red Hat OpenShift Assisted Installer Chat RAG content"
LABEL io.k8s.display-name="Red Hat OpenShift Assisted Installer Chat RAG content"
LABEL io.openshift.tags="openshift,assisted-installer-chat,ai,assistant,rag"
LABEL name=openshift-assisted-installer-chat-rag-content
LABEL release=0.0.1
LABEL url="https://github.com/carbonin/assisted-chat-rag"
LABEL vendor="Red Hat, Inc."
LABEL version=0.0.1
LABEL summary="Red Hat OpenShift Assisted Installer Chat RAG content"

USER 65532:65532
