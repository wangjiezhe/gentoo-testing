FROM gentoo/portage:latest as portage
FROM gentoo/stage3:desktop as production

COPY --from=portage /var/db/repos/gentoo/ /var/db/repos/gentoo

WORKDIR /
ENV PATH="/root/.local/bin:${PATH}"
RUN set -eux;                                                                       \
                                                                                    \
    eselect news read --quite new >/dev/null 2&>1;                                  \
    emerge --info;                                                                  \
    emerge --verbose --quiet --jobs $(nproc) --autounmask y --autounmask-continue y \
        app-eselect/eselect-repository                                              \
        app-portage/eix                                                             \
        app-portage/genlop                                                          \
        app-portage/gentoolkit                                                      \
        app-portage/iwdevtools                                                      \
        app-portage/mgorny-dev-scripts                                              \
        app-portage/portage-utils                                                   \
        app-portage/repoman                                                         \
        app-misc/neofetch                                                           \
        dev-python/pip                                                              \
        dev-util/pkgdev                                                             \
        dev-util/pkgcheck                                                           \
        dev-vcs/git;                                                                \
                                                                                    \
    emerge --info;                                                                  \
    eix-update;

CMD ["/bin/bash"]
