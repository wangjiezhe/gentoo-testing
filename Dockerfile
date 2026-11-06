FROM gentoo/portage:latest as portage
FROM gentoo/stage3:amd64-desktop-systemd as production

COPY --from=portage /var/db/repos/gentoo/ /var/db/repos/gentoo
COPY init.sh /

WORKDIR /
ENV PATH="/root/.local/bin:${PATH}"
RUN set -eux;                                                                               \
                                                                                            \
    eselect news read --quiet new >/dev/null 2>&1;                                          \
    echo 'FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox"' >> /etc/portage/make.conf; \
    echo '*/* python perl' >> /etc/portage/package.use/global;                              \
    echo 'FEATURES="${FEATURES} getbinpkg"' >> /etc/portage/make.conf;                      \
    emerge --info;                                                                          \
    getuto;                                                                                 \
    emerge --verbose --quiet --jobs $(nproc) --autounmask y --autounmask-continue y         \
        app-eselect/eselect-repository                                                      \
        app-editors/vim                                                                     \
        app-portage/eix                                                                     \
        app-portage/flaggie                                                                 \
        app-portage/genlop                                                                  \
        app-portage/gentoolkit                                                              \
        app-portage/iwdevtools                                                              \
        app-portage/mgorny-dev-scripts                                                      \
        app-portage/portage-utils                                                           \
        app-misc/jq                                                                         \
        dev-python/jq                                                                       \
        app-misc/neofetch                                                                   \
        app-text/tree                                                                       \
        dev-python/pip                                                                      \
        dev-util/pkgdev                                                                     \
        dev-util/pkgcheck                                                                   \
        dev-vcs/git;                                                                        \
                                                                                            \
    rm --recursive /var/db/repos/gentoo;                                                    \
    eselect repository add gentoo git https://github.com/gentoo-mirror/gentoo.git;          \
    eselect repository enable gentoo-zh guru sage-on-gentoo;                                \
    emerge --sync;                                                                          \
    ln -s /var/db/repos/sage-on-gentoo/tools/package.keywords/sage                          \
          /etc/portage/package.accept_keywords/sage;                                        \
    ln -s /var/db/repos/sage-on-gentoo/tools/package.use/sage                               \
          /etc/portage/package.use/sage;                                                    \
    mkdir -p /etc/portage/sets;                                                             \
    ln -s /var/db/repos/sage-on-gentoo/tools/sets/sagemath                                  \
          /etc/portage/sets/sagemath;                                                       \
    ln -s /var/db/repos/sage-on-gentoo/tools/sets/sagemath-optional                         \
          /etc/portage/sets/sagemath-optional;                                              \
    emerge --verbose --quiet --jobs $(nproc) --autounmask y --autounmask-continue y --update\
        --deep --newuse @world;                                                             \
    emerge --verbose --quiet --jobs $(nproc) --autounmask y --autounmask-continue y         \
        dev-python/nvchecker;                                                               \
                                                                                            \
    sed -i '/FEATURES="${FEATURES} getbinpkg"/d' /etc/portage/make.conf;                    \
    rm --recursive /var/cache/binhost/* /var/cache/distfiles/*;                             \
                                                                                            \
    nvchecker --version


CMD ["/bin/bash"]
