FROM debian:jessie

ENV MONO_THREADS_PER_CPU 50
RUN MONO_VERSION=5.0.1.1 && \
    FSHARP_VERSION=4.1.25 && \
    FSHARP_PREFIX=/usr && \
    FSHARP_GACDIR=/usr/lib/mono/gac && \
    FSHARP_BASENAME=fsharp-$FSHARP_VERSION && \
    FSHARP_ARCHIVE=$FSHARP_VERSION.tar.gz && \
    FSHARP_ARCHIVE_URL=https://github.com/fsharp/fsharp/archive/$FSHARP_VERSION.tar.gz && \
    # See http://download.mono-project.com/repo/debian/dists/wheezy/snapshots/
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list && \
    apt-get update -y && \
    apt-get --no-install-recommends install -y autoconf libtool pkg-config make automake nuget mono-devel msbuild ca-certificates-mono && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    printf "namespace a { class b { public static void Main(string[] args) { new System.Net.WebClient().DownloadFile(\"%s\", \"%s\");}}}" $FSHARP_ARCHIVE_URL $FSHARP_ARCHIVE > download-fsharp.cs && \
    mcs download-fsharp.cs && mono download-fsharp.exe && rm download-fsharp.exe download-fsharp.cs && \
    tar xf $FSHARP_ARCHIVE && \
    cd $FSHARP_BASENAME && \
    ./autogen.sh --prefix=$FSHARP_PREFIX --with-gacdir=$FSHARP_GACDIR && \
    make && \
    make install && \
    cd ~ && \
    rm -rf /tmp/src /tmp/NuGetScratch ~/.nuget ~/.config ~/.local && \
    apt-get purge -y autoconf libtool make automake && \
    apt-get clean

# install some additional dev tools desired or required
RUN apt-get update -y 
RUN apt-get install -yq apt-utils 
# we install vim-python-jedi instead of just vim to get python env required fsharp-vim plugin
RUN apt-get install -yq vim-python-jedi man less ctags wget curl git subversion ssh-client 
RUN apt-get install -yq make unzip

# set up dfvim user with uid 1000 to (hopefully) match host uid
RUN useradd --shell /bin/bash -u 1000 -o -c "" -m dfvim
RUN mkdir /src && chown dfvim /src/ -R
USER dfvim

# set .bashrc and .vimrc (not .vimrc sets up fsharp-vim plugin using vim-plug system))
WORKDIR /home/dfvim
COPY .bashrc .
COPY .vimrc .

# install vim-plug and run setup 
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim +PlugInstall +qall

WORKDIR /src
CMD ["/bin/bash"]
