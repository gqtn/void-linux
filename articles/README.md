### Void Linux
### Guia de Instalação Rápida

Esse manual surgiu com propósito de guiar novos usuários de Void Linux durante a instalação e pós instalação.
A instalação guiada garante:

- Instalação com `BtrFS`, com possibilidade de snapshots;
- Instalação de serviços prioritários (`dbus`);
- Instalação de servidor de áudio (`pipewire` com gestão via `pavucontrol`);
- Instalação focada em `Xorg` com `i3-wm`.

---
### 1. Instalação

Para facilitar a instalação, usaremos um script otimizado:

- Faça download da ISO do Void Linux no [site oficial](https://voidlinux.org/download/)
   - Recomendo a instalação *base* com *glibc*
- Faça a gravação da ISO em um dispositivo de armazenamento externo:
```bash
sudo dd if=path/to/iso of=/dev/seudisco bs=1M oflag=sync status=progress
```
- Na página de instalação do Void Linux, acesse o sistema com as credenciais informadas;
- Rode os seguintes comandos, em ordem!
> **Nota1**: Lembre-se que não existe `bash-completion` nessa etapa; ou seja, o `<TAB>` não funciona.
> **Nota2**: Nesse momento, seu teclado deve estar no modelo inglês, então tome cuidado.

```bash
# Instalação de pacotes base:
sudo xbps-install -Suy xbps wget

# Baixando o executável de instalação:
wget https://github.com/sdbtools/void-pi/releases/latest/download/void-pi.x86_64.tgz

# Abrindo o tar
tar -xzf void-pi.x86_64.tgz

# Execute o instalador:
./void-pi
```
- Nesse momento, basta seguir, cuidadosamente, as etapas de instalação guiada, selecionando corretamente os discos para instalação e outras etapas de configuração.
- Aguarde a conclusão da instalação, clique em sair e dê reboot ao sistema.

---
### 2. Pós Instalação

- Após instalação, certifique-se que tem conectividade de internet:
    - Se estiver usando cabo ethernet, possivelmente terá conectividade;
    - Caso contrário, pesquise como conectar no Wi-Fi via `wpa_supplicant` e `dhcpd`.
```bash
ip -br -c a
```

- Para facilitar a instalação, vamos primeiramente atualizar o sistema:
```bash
sudo xbps-install -Suy
# Aguarde a instalação!
```

- Vamos instalar o Bash Completion para facilitar nossa vida:
```bash
sudo xbps-install -S bash-completion
```
> **Lembre-se de fazer logout e login para carregar o bash-completion!**


- E também vamos ativar o repositório *non-free*, com:
```bash
sudo xbps-install -S void-repo-nonfree
```

- Quando terminado, instalaremos alguns pacotes fundamentais para uso do sistema sem `systemd`:

> [Instalaremos um IPC D-Bus](https://docs.voidlinux.org/config/session-management.html#d-bus):
```bash
sudo xbps-install -S dbus
```

> Agora, um [gerenciador de usuários e sistema de energia](https://docs.voidlinux.org/config/session-management.html#elogind):
```bash
sudo xbps-install -S elogind
```

> Instalaremos uma [ferramenta para lidar com a internet e interfaces](https://docs.voidlinux.org/config/network/networkmanager.html#networkmanager):
```bash
sudo xbps-install -S NetworkManager
```

> Um simples visualizados de processos:
```bash
sudo xbps-install -S vsv
```

> E por fim, instalaremos um [gerenciador simples de logs](https://docs.voidlinux.org/config/services/logging.html#socklog):
```bash
sudo xbps-install -S socklog-void
```

- Para iniciar corretamente os serviços, precisaremos desativar alguns outros. Verifique os processos ativos com:
```bash
sudo vsv
```

- Devemos remover:
```bash
sudo rm /var/service/acpid
sudo rm /var/service/wpa_supplicant
sudo rm /var/service/dhcpd
```

- E adicionaremos os novos serviços:
```bash
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/
sudo ln -s /etc/sv/socklog-unix /var/service/
sudo ln -s /etc/sv/nanoklogd /var/service/
```

Em resumo, isso garantirá um sistema preparado para as demais instalações! :)
> **Nota3:** O `elogind` será gerenciado pelo `dbus`, então não adicione ele como serviço!
> **Nota4:** Para checar os logs, basta olhar `/var/log/socklog/` ou diretamente via comando `svlogtail`.

---
### Firmwares

O Void Linux tem uma descrição bem detalhada dos firmwares que você precisa instalar e/ou que são recomendados. Como uma rápida explicação, os *firmwares* são binários instalados diretamente no seu hardware, e os *drivers* ficam sob responsabilidade do Kernel Linux.

Os firmwares básicos são instalados durante a instalação, mas é necessário garantir outros específicos.
> **Nota 5:** lembrando que esses pacotes estão no repositório *non-free*!

- Para **AMD**, instale o pacote `linux-firmware-amd`

- Para **Intel**, instale o pacote `intel-ucode`. 

E também já instalaremos um pacote necessário para termos o funcionamento do áudio:
```bash
sudo xbps-install -S sof-firmware
```

> **Nota 6:** os firmwares só serão habilitados completamente após reboot do sistema! Mas podemos rebootar em breve.

---
### Áudio

Como o Void Linux é uma distro *systemd free*, isso singifica que teremos algumas etapas manuais que antes seriam completamente escondidas de você, e isso também significa ajustes no áudio. Para isso, vamos instalar alguns pacotes e alterar alguns scripts:

- Vamos começar com as instalações, usando um sistema de áudio atual:
```bash
sudo xbps-install -S pipewire wireplumber pavucontrol
```

O `pipewire` é o servidor de áudio e o `wireplumber` é responsável por fazer as conexões.
Como usaremos o `pavucontrol`, que é um editor de áudio gráfico, precisaremos iniciar um processo manualmente chamado `pipewire-pulse`, que já vem instalado com o `pipewire` por padrão. Para isso, podemos fazer de diversas formas.

Uma forma utilizada é adicionar algumas linhas em `.xinitrc`, mas, faremos isso depois utilizando `dbus` e o `i3`.

---
### Xorg, i3 e Vídeo

Colocarei alguns softwares que uso na minha instalação, sinta-se a vontade para fazer adaptações.
Os softwares que forem específicos e importantes, colocarei algumas notas.

```bash

sudo xbps-install -S \
xorg \
i3 \
i3lock \
polybar \
rofi \
alacritty \
tmux \
picom \
arandr \
nwg-look \
arc-theme \
ffmpeg \
vivaldi \
papirus-icon-theme \
nerd-fonts \
ttf-ubuntu-font-family \
noto-fonts-emoji \
xmirror \
xtools \
maim \
scrot \
ImageMagick \
feh \
xclip \
xdotool \
xdg-desktop-portal-gnome \
brightnessctl \
xset \
setxkbmap \
polkit-gnome \
htop
```

Essa é uma base ótima para termos suporte à fontes, ícones, gerenciadores de sessão/senha, e um ambiente completo.

Em especial:
- `picom` como compositor
- `nwg-look` para facilitar a configuração de temas GTK no ambiente
- `xmirror` para gerenciar espelhos mais rápidos do Void Linux
- `xclip`, `xdotool`, `maim`, `scrot` e `ImageMagick` para capturas de tela e afins
- `xdg-desktop-portal-gnome` para ajudar na abertura correta de programas
- `feh` para definir papel de parede
- `polkit-gnome` para gerenciar programas com acesso `root`
- `brightnessctl` para gerenciamento de brilho
- E o `dunst` para gerenciar notificações (que não uso).

--- 
### Sessão

Após instalação de todos esses pacotes, é recomendado rebootar o sistema.
Quando iniciar, verifique sua conexão novamente e se todos os serviços iniciaram corretamente.

Se postivio, crie antes de carregar o `i3`, crie um arquivo em `$HOME`:
```bash
vi .xinitrc
```

E adicione o seguinte conteúdo:
```bash
exec dbus-run-session i3
```
Assim vamos garantir que o gerenciador de sessão será carregado corretamente.
Quando finalizar, aproveite para carregar uma configuração ao X11 para ajeitar seu teclado:

```bash
sudo vi /usr/share/X11/xorg.conf.d/90-touchpad.conf
```
E adicione:
```bash
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "on"
        Option "ScrollMethod" "twofinger"
EndSection
```

Neste ponto, pode reiniciar mais uma vez.

---
### Finalizações

Quando reiniciar mais uma vez, verifique suas conexões e afins, e carregue a sessão digitando: `startx`.

Neste ponto, você deverá configurar seu ambiente com seu gosto pessoal e dotfiles - se houver. Entretanto, *recomendo fortemente* algumas configurações:

Em seu `$HOME/.config/i3/config`, adicione algumas linhas:
```bash
# +---+ Startup +---+
exec --no-startup-id setxkbmap -model abnt2 -layout br
exec --no-startup-id picom

exec --no-startup-id $HOME/.screenlayout/default.sh
exec --no-startup-id $HOME/.config/i3/audio.sh

exec --no-startup-id /usr/libexec/polkit-gnome-authentication-agent-1
exec --no-startup-id xset s off -dpms
exec --no-startup-id brightnessctl set 8000
```

Perceba que o `i3` inicia serviços de remapeamento do teclado, descanso de tela, compositor e afins.

- Para organizar configurações de layout de tela - criados pelo `arandr` - basta fazer as configurações que quiser por ele, via GUI, e depois salvar o arquivo em `$HOME/.screenlayout/default.sh` uma vez, e sempre carregá-lo via `i3`.

- Para organizar o áudio, conforme conversamos, crie um arquivo em `.config/i3/audio.sh` com o seguinte conteúdo:
```bash
#!/bin/bash

exec pipewire &
sleep 0.8

exec wireplumber &
sleep 0.8

exec pipewire-pulse &
sleep 0.8

exec polybar &
```

Assim você garante que o áudio funcionará sem problemas e será reconhecido via `polybar`.

---
### Considerações

Existem outras configurações interessantes, mas neste momento você está preparado para ter um sistema funcional. Lembre-se de ler a documentação completa e, em caso de dúvidas, sinta-se a vontade para me escrever via issues.

Welcome to the Void Linux experience! :)
