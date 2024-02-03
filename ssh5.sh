#!/bin/bash


echo "Escolha uma opção de tipos de portas ou digite '6' para busca manual de IP e portas:"
echo "1. Porta manual"
echo "2. Portas de transmissão de imagem por câmeras"
echo "3. Portas de servidores de arquivos"
echo "4. Portas de acesso remoto a sistemas operacionais"
echo "5. Portas de serviços diversos"
echo "6. Busca manual de IP e portas"
read user_option

if [ "$user_option" == "1" ]; then
    echo "Digite o número da porta que deseja verificar:"
    read port
elif [ "$user_option" == "2" ]; then
    port="554,8554,7070,1935,8080,8090,9000,9001,88"
elif [ "$user_option" == "3" ]; then
    port="20,21,137,138,139,445,2049"
elif [ "$user_option" == "4" ]; then
    port="22,3389,5900,5901,5902"
elif [ "$user_option" == "5" ]; then
    port="80,443,25,110,143,993,995,3306,5432,27017"
elif [ "$user_option" == "6" ]; then
    echo "Digite o endereço IP que deseja verificar (deixe em branco para usar o IP local):"
    read ip
    echo "Digite a porta que deseja verificar (deixe em branco para procurar todas as portas):"
    read port
    if [ -z "$ip" ]; then
        ip=$(hostname -I | cut -d ' ' -f 1)
    fi
    if [ -z "$port" ]; then
        port="1-65535"
    fi
else
    echo "Opção inválida."
    exit 1
fi

if [ -z "$port" ]; then
    echo "Nenhuma porta especificada. Procurando por hosts com alguma porta aberta."
    port="1-65535"
fi

echo "Digite o número mínimo de hosts abertos que deseja exibir:"
read min_hosts

echo "Deseja buscar por IPs próximos à sua região? (s/n)"
read answer

if [ "$answer" == "s" ]; then
    echo "Buscando por IPs próximos à sua região..."
    ip=$(curl -s http://whatismyip.akamai.com/)
    region=$(echo $ip | cut -d'.' -f1,2)
fi

IFS=',' read -ra PORTS <<< "$port"

hosts_encontrados=0
hosts_verificados=0
table="| Endereço IP    | Portas Testadas | Portas Abertas |\n"

while [ $hosts_encontrados -lt $min_hosts ]
do
    if [ "$answer" == "s" ]; then
        host="$region.$(shuf -i 1-254 -n 1).$(shuf -i 1-254 -n 1)"
    else
        host=$(shuf -i 1-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)
    fi

    portas_abertas=""
    portas_testadas=""

    for p in "${PORTS[@]}"; do
        output=$(nmap --max-retries 2 --min-rate=500 -T4 -p $p $host)

        if [[ $output == *"(0 hosts up)"* ]]; then
            continue
        elif [[ $output == *"closed"* ]]; then
            portas_testadas+="$p, "
            continue
        elif [[ $output == *"open"* ]]; then
            portas_testadas+="$p, "
            echo "Host $hosts_verificados ($host): porta $p aberta"
            portas_abertas+="$p, "
        fi
    done

    if [ -n "$portas_abertas" ]; then
        hosts_encontrados=$((hosts_encontrados+1))
        table+="| $host | ${portas_testadas%, } | ${portas_abertas%, } |\n"
        xterm -hold -e "nmap -sS -A -p ${portas_abertas%, } $host" &
    fi

    hosts_verificados=$((hosts_verificados+1))
    echo "Verificando host $hosts_verificados ($host) - $hosts_encontrados hosts abertos encontrados até agora"
done

echo -e $table
