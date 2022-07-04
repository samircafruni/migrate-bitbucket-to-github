#!/bin/bash
clear

username=
password=
organization=

repos=(
    git@bitbucket.org:studiovisual/xxxxxxxxxxxxxxxxxxxx.git
    git@bitbucket.org:studiovisual/xxxxxxxxxxxxxxxxxxxx.git
    git@bitbucket.org:studiovisual/xxxxxxxxxxxxxxxxxxxx.git
    git@bitbucket.org:studiovisual/xxxxxxxxxxxxxxxxxxxx.git
)

for var in "${repos[@]}"; do
    echo "Clonando repositório..."
    git clone --bare $var temp
    clear

    echo "Criando novo repositório no GitHub..."
    cd temp
    new_repo_name=$(git config --get remote.origin.url | cut -d/ -f2- | cut -d. -f1) 

    # Se a var organization estiver vazia, o script usa a API pessoal do dev.   
    if [ -z "$organization" ]
        then
            curl -u "${username}:${password}" https://api.github.com/user/repos -d "{\"name\":\"$new_repo_name\", \"private\":\"true\"}" 
        else
            curl -u "${username}:${password}" https://api.github.com/orgs/$organization/repos -d "{\"name\":\"$new_repo_name\", \"private\":\"true\"}"
    fi
    clear

    # Se a var organization estiver vazia, o script usa o repo pessoal do dev.   
    echo "Migrando repositório..."
    if [ -z "$organization" ]
        then
            git remote set-url origin git@github.com:$username/$new_repo_name.git
            git push --mirror git@github.com:$username/$new_repo_name.git
        else
            git remote set-url origin git@github.com:$organization/$new_repo_name.git
            git push --mirror git@github.com:$organization/$new_repo_name.git
    fi
    clear

    echo "Removendo diretório temporário..."
    cd ..
    rm -vrf temp
    clear
done

echo "Migração concluída com sucesso!"
set -e
