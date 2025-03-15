FROM gentoo/portage:latest as portage
FROM gentoo/stage3 as production

COPY --from=portage /var/db/repos/gentoo/ /var/db/repos/gentoo
COPY gentoo.conf /etc/portage/repos.conf/
COPY local.conf /etc/portage/repos.conf/
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
    emerge --sync gentoo;                                                                   \
    emerge --info;                                                                          \
                                                                                            \
    emerge --sync local;                                                                    \
                                                                                            \
    pkgcheck cache --update --repo gentoo;                                                  \
                                                                                            \
    eselect repository enable gentoo-zh guru;                                               \
    emerge --sync gentoo-zh guru;                                                           \
    emerge --verbose --quiet --jobs $(nproc) --autounmask y --autounmask-continue y         \
        dev-python/nvchecker;                                                               \
                                                                                            \
    sed -i '/FEATURES="${FEATURES} getbinpkg"/d' /etc/portage/make.conf;                    \
    rm --recursive /var/cache/binpkgs/* /var/cache/distfiles/*;                             \
                                                                                            \
    nvchecker --version


CMD ["/bin/bash"]
