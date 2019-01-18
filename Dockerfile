FROM ubuntu:18.10
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq -y \
	apache2-utils \
	apt-transport-https \
	build-essential \
	bzr \
	ca-certificates \
	clang \
	cmake \
	curl \
	default-libmysqlclient-dev \
	default-mysql-client \
	direnv \
	dnsutils \
	docker.io \
	fakeroot-ng \
	gdb \
	git \
	git-crypt \
	gnupg \
	gnupg2 \
	htop \
	hugo \
	ipcalc \
	jq \
	less \
	libclang-dev \
	liblzma-dev \
	libpq-dev \
	libprotoc-dev \
	libsqlite3-dev \
	libssl-dev \
	libvirt-clients \
	libvirt-daemon-system \
	lldb \
	locales \
	man \
	mosh \
	mtr-tiny \
	musl-tools \
	ncdu \
	netcat-openbsd \
	openssh-server \
	pkg-config \
	postgresql-contrib \
	protobuf-compiler \
	pwgen \
	python \
	python3 \
	python3-flake8 \
	python3-pip \
	python3-setuptools \
	python3-venv \
	python3-wheel \
	qemu-kvm \
	qrencode \
	quilt \
	ripgrep \
	shellcheck \
	silversearcher-ag \
	socat \
	software-properties-common \
	sqlite3 \
	stow \
	sudo \
	tig \
	tmate \
	tmux \
	tree \
	unzip \
	wget \
	zgen \
	zip \
	zlib1g-dev \
	zsh \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config

RUN add-apt-repository ppa:jonathonf/vim -y && apt-get update && apt-get install vim-gtk3 -y

RUN wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz && rm go1.11.4.linux-amd64.tar.gz

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	locale-gen --purge $LANG && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE

# for correct colours is tmux
ENV TERM screen-256color

EXPOSE 3222 60000-60010/udp

# Create a user
ENV USER=dev
RUN set -x -e && \
    useradd -G docker -m -s /usr/bin/zsh "$USER" && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV PATH="$GOPATH/bin:$PATH"

# Set default environment variables
ENV EDITOR=vim
ENV GOPATH="$HOME"
ENV GHQ_ROOT="$HOME/src"
ENV GITHUB_USER="yuanying"

COPY entrypoint.sh /bin/entrypoint.sh
CMD ["/bin/entrypoint.sh"]