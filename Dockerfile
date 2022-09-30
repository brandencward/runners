# Base image for texlive runners on ARM64
FROM menci/archlinuxarm:base

RUN pacman -Sy texlive-core texlive-formatsextra texlive-latexextra texlive-bibtexextra ttf-lato --noconfirm && rm -r /var/cache/pacman/pkg/*

COPY texlive-fonts-fontawesome-2021.61408-1-any.pkg.tar .

RUN pacman -U texlive-fonts-fontawesome-2021.61408-1-any.pkg.tar --noconfirm

RUN mkdir -p /var/run/secrets/kubernetes.io/serviceaccount

WORKDIR /usr/share/fonts/TTF

RUN for i in https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Black.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Bold.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-ExtraBold.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-ExtraLight.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Light.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Medium.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Regular.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-SemiBold.ttf https://raw.github.com/googlefonts/robotoslab/master/fonts/ttf/RobotoSlab-Thin.ttf; do curl -LJO $i; done && fc-cache

RUN mkdir /runner && mkdir /runnertmp && cd /runnertmp

WORKDIR /runnertmp

RUN curl -o actions-runner-linux-arm64-2.287.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.287.1/actions-runner-linux-arm64-2.287.1.tar.gz && tar xzf ./actions-runner-linux-arm64-2.287.1.tar.gz && rm ./actions-runner-linux-arm64-2.287.1.tar.gz

COPY entrypoint.sh /usr/bin/

RUN chown 1001:121 /usr/bin/entrypoint.sh && chmod +x /usr/bin/entrypoint.sh

USER 1001

ENTRYPOINT ["/usr/bin/bash", "-c", "/usr/bin/entrypoint.sh"]