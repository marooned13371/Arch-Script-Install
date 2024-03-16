#!/usr/bin/env bash

clear

if ! [[ $UID -eq "0" ]]; then echo "Execute como root" ; fi

function viewDisks() {
  while true; do
    read -p "Deseja ver os discos dessa maquina S/N ? " resp
    if [[ $resp =~ ^[Ss]$ ]]; then 
      sleep 1
      clear
      mostrarDiscos=$(lsblk -d -l -o NAME,SIZE)
      echo "$mostrarDiscos"
      break
    elif [[ $resp =~ ^[Nn]$ ]]; then
      sleep 1
      clear
      echo "Ok..."
      break
    else
      echo "Opcao invalida, coloque entre S/N"
    fi
  done
}

function apagarTabParticoes(){
  echo "Apagando a tabela de particoes do disco: $disco "
  sobrescrever=$(dd if=/dev/zero of=$disco bs=512 count=1 conv=notrunc)
}

function initPart(){

  while true; do
    echo -e "\nQual disco voce deseja particionar ?\nEx: /dev/sda /dev/nvme /dev/sdb..." 
    read disco
    if ! [[ -e $disco ]]; then
      echo "Disco invalido, tente novamente"
    else
      echo "Dando continuidade ao script"
      sleep 1
      break
    fi
  done
  
  clear

  echo "Iniciando particionamento no disco: $disco ! "
  echo -e "Se tiver alguma dúvida na hora de fazer o particionamento visite:\n"
  while true; do
    sleep 2 
    cfdisk $disco
    read -p "Voce deseja alterar o disco novamente N/s ?" respPart 
    if [[ $respPart =~ ^[Ss]$ ]]; then
      read -p "Deseja sobrescrever a tabela de particoes S/n ?"  respSob
      if [[ $respSob =~ ^[Ss]$ ]]; then
        apagarTabParticoes
      fi
    elif [[ $respPart =~ ^[Nn]$  ]]; then
      echo -e "Ok, Continuando o script..."
      sleep 1
      break
    fi
  done
}

<<<<<<< HEAD
function tiposFS(){

  declare -a tipoFS=("FAT ", "EXT2 " , " EXT3 ", " EXT4 ", " BTRFS ", "XFS ")
  select tipo in ${tipoFS[@]} ; do 
    case $tipo in
      FAT)      
        ;;
      EXT2)
        ;;
      EXT3)
        ;;
      EXT4)
        ;;
      BTRFS)
        ;;
      XFS)
        ;;
      Sair)
        ;;
      *)
        ;;
    esac
  done

}

function viewDisksFormat() {
      mostrarDiscosPart=$(lsblk -p -n -o NAME -r | sed -e "1s|^|Disco: |" -e "/^\/dev/\sda[1-9]/{s|^| | }" | grep -vE '/dev/(loop|sr)[0-9]+')
      select particao in $mostrarDiscosPart; do
        if ! [[ $particao = "/dev/sda" ]]; then
          echo "Particao selecionada $mostrarDiscosPart"
            
          tiposFS

          echo -e "\nVoltando para o menu de selecao de particoes"
          
        fi
      done
        
}

function formatDisks(){
  viewDisksFormat
  echo -e "\n -------------------------------"
  tipoFS
  
  done
=======
function formateDisks(){

  echo "Formatando as particoes do disco $disco "
  particoes=($(lsblk -n -o NAME "$disco" | grep -E "{$disco}[0-9]+" ))

  for particao in "${particoes[@]}"; do
    read -p "Deseja formatar a particao $particao S\n ?" resp

    if [[ "$resp" =~ ^[Ss]$ || -z "$resp" ]]; then
      echo "Escolha um sistema de arquivos para a particao: $particao "
      select filesystem in "FAT" "swap" "ext4" "ext3" "ext2" "btrfs" ;do
        case $filesystem in
          ext4|ext3|ext2|btrfs)
            mkfs."$filesystem" "$particao"
            echo "Particao $particao com o formato: $filesystem "
            break
            ;;
          swap)
            mkswap "$particao"
            swapon "$particao"
            echo "Particao $particao com o formato: "$filesystem" , o swap foi ativo. "
            break
            ;;
          FAT)
            mkfs.fat -F 32 $particao 
            echo "Particao $particao com o formato: $filesystem, lembrando que a particao FAT é somente utilizada para a particao de boot nesse caso. "
            break
            ;; 
        esac
      done
    fi
  done


}

viewDisks
initPart
formateDisks
