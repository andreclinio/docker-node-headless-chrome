#!/bin/bash

prompt_yes_no() {
  local prompt_message="$1"
  local user_input

  while true; do
    read -p "$prompt_message (y/n): " user_input
    case "$user_input" in
      [Yy]* ) return 0;;  # Yes response
      [Nn]* ) return 1;;  # No response
      * ) echo "Please answer yes or no.";;
    esac
  done
}

# Loop de argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -mj|--major)
            shift
            export incMode="major"
            ;;
        -mn|--minor)
            shift
            export incMode="minor"
            ;;
        -pt|--patch)
            shift
            export incMode="patch"
            ;;
        -no|--none)
            shift
            export incMode="none"
            ;;
        -bt|--beta)
            shift
            export isBeta="true"
            ;;
        -d|--dry-run)
            shift
            export dryRun="true"
            ;;
        -h|--help)
            shift
            echo "Opções:"
            echo "  -mj | --major          : major +.x.x"
            echo "  -mn | --minor          : minor x.+.x"
            echo "  -pt | --patch          : patch x.x.+"
	    echo "  -no | --none           : x.x.x (no increment - used to remove beta versions)"
            echo "  -bt | --beta           : beta x.x.x-beta.<CODE>"
            echo "  -d  | --dry-run        : modo de verificação -- não executada nada no *git* (dry-run)"
            exit 0
            ;;
        *)
            echo "** AVISO **: Opção desconhecida (descartada): $1;  Use -h ou --help"
            shift
            ;;
    esac
done

# Teste de incremento defininido
if [ -z "$incMode" ]; then
	echo "** ERRO **: Informe o tipo de incremento de versão (ver argumento --help)"
	exit 1
fi

# Teste de modificações locais
if git diff-index --quiet HEAD --; then
   echo "Sem mods locais. Continuando..."
else
   echo "** ERRO **: Modificações locais detectadas"
   if [ -z "$dryRun" ]; then
      exit 1
   fi
fi

currVersion=`git describe --tags --abbrev=0`
_currVersion=`echo $currVersion | sed 's/-beta.*//'`
echo "Versão corrente: $currVersion (base: $_currVersion)"

VERSION_BITS=(${_currVersion//./ })

#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}

#echo "debug $VNUM1 $VNUM2 $VNUM3"

if [ "$incMode" == "major" ]; then
   VNUM1=$((VNUM1+1))
   VNUM2=0
   VNUM3=0
elif [ "$incMode" == "minor" ]; then
   VNUM2=$((VNUM2+1))
   VNUM3=0
elif [ "$incMode" == "patch" ]; then
   VNUM3=$((VNUM3+1))
fi

nextVersion="$VNUM1.$VNUM2.$VNUM3"
if [ ! -z "$isBeta" ]; then
   hash=`git describe --long --always | awk -F'-' '{print $NF}' | sed 's/^g//'`
   nextVersion="$nextVersion-beta.$hash"
fi

echo "Argumentos:"
echo "- Versão corrente: $currVersion"
echo "- Tag a ser criada: $nextVersion"
echo "- Modo teste (dry-run): $([ -z "$dryRun" ] && echo "não" || echo "SIM")"
echo "- Beta: $([ -z "$isBeta" ] && echo "não" || echo "SIM")"
prompt_yes_no "Confirma?"
confirmed=$?
if [[ confirmed -eq 1 ]]; then
   echo "Operação cancelada"
   exit 1;
fi

echo "Executando..."
#exit 1;

if [ -z "$dryRun" ]; then
   git tag -a $nextVersion -m "Criação da tag $nextVersion"
   git push origin $nextVersion
else
   echo "Simulação de escrita em $versionFile com o valor da tag $nextVersion"
   echo "Simulação de add/commit de $versionFile e git push"
   echo "Simulação de criação da tag de $nextVersion (git tag) e push"
   echo "Dry run: nada a fazer..."
fi



