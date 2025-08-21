# Node e Chrome Image

## Desenvolvimento

Principais procedimentos e comandos.

### Atualizando Chrome local

```bash
$ wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
(...)

$ dpkg --install google-chrome-stable_current_amd64.deb
(...)

$ google-chrome --version
Google Chrome XXX.XXXX.x

```

### Criando uma tag de versão

Usar script `release.bash` (ver help --h)

```bash
$ ./release.bash
(...)
```

### Publicando a nova versão

Usar script `publish.bash`, dentro da tag - a versão vai usar o comando `git describe` para
a tag no docker hub.

```bash
$ git checkout tags/X.X.X
(...)

$ ./publish.bash
(...) 
```

### Testando uma versão local (após `./build-local.bash`) ou do DockerHub (remoto)

Rodando a imagem local ou remota como bash para ver versão do Chrome

```bash
$ docker run -it --rm docker-node-headless-chrome:x.x.x bash
(...)

$ docker run -it --rm andreclinio/docker-node-headless-chrome:x.x.x bash
(...)

# google-chrome --version
Google Chrome XXX.X.XXXX.XX
```
