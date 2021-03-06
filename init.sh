#!/bin/bash

ONEKEY_ZK_ENV_PATH=`(pwd)`
. $ONEKEY_ZK_ENV_PATH/sh/function.sh
. $ONEKEY_ZK_ENV_PATH/sh/color.sh

sysType=$(uname -s)
case $sysType in
    "Linux")
        isStringInFile ONEKEY_ZK_ENV_PATH ~/.profile
        if [ $? = 0 ]; then
            echo export ONEKEY_ZK_ENV_PATH="$ONEKEY_ZK_ENV_PATH" >> ~/.profile && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.profile
        fi
        source ~/.profile
        ;;
    "Darwin")
        shellType=`echo $SHELL`
        $OUTPUT "current shell type is $shellType..."
        if [[ $shellType =~ "bash" ]] || [[  $shellType =~ "-bash" ]]; then
            isStringInFile ONEKEY_ZK_ENV_PATH ~/.bashrc
            if [ $? = 0 ]; then
                echo export ONEKEY_ZK_ENV_PATH="$ONEKEY_ZK_ENV_PATH" >> ~/.bashrc && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.bashrc
            fi
            $OUTPUT "ONEKEY_ZK_ENV_PATH has been set to environment file ~/.bashrc..."
            source ~/.bashrc
        elif [[ $shellType =~ "zsh" ]] || [[  $shellType =~ "-zsh" ]]; then
            if [ ! -f ~/.zshrc.pre-oh-my-zsh ]; then
                isStringInFile ONEKEY_ZK_ENV_PATH ~/.zshrc
                if [ $? = 0 ]; then
                    echo export ONEKEY_ZK_ENV_PATH="$ONEKEY_ZK_ENV_PATH" >> ~/.zshrc && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.zshrc
                fi
                $OUTPUT "ONEKEY_ZK_ENV_PATH has been set to environment file ~/.zshrc..."
            else
                isStringInFile ONEKEY_ZK_ENV_PATH ~/.zshrc.pre-oh-my-zsh
                if [ $? = 0 ]; then
                    echo export ONEKEY_ZK_ENV_PATH="$ONEKEY_ZK_ENV_PATH" >> ~/.zshrc.pre-oh-my-zsh && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.zshrc.pre-oh-my-zsh && zsh &&  ~/.zshrc
                fi
                $OUTPUT "ONEKEY_ZK_ENV_PATH has been set to environment file ~/.zshrc.pre-oh-my-zsh..."
            fi
            source ~/.zshrc
        fi
        ;;
    *)
        $OUTPUT "system $sysType not supported!"
        exit -1
        ;;
esac

$OUTPUT "Seting Env ONEKEY_ZK_ENV_PATH $ONEKEY_ZK_ENV_PATH successfully..."

onekey-zk help