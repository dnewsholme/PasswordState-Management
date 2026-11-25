FROM mcr.microsoft.com/powershell:lts-ubuntu-22.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git procps lsb-release ca-certificates curl wget jq sudo zsh openssh-client \
    && groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" -m -s "$(which pwsh)" "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN pwsh -NoProfile -NonInteractive -Command "\
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
    Install-Module PowerShellGet -Scope AllUsers -Force; \
    Install-Module Pester -MaximumVersion 4.99.99 -Scope AllUsers -Force -SkipPublisherCheck; \
    Install-Module PSFramework -Scope AllUsers -Force"
