#!/bin/bash
set -e

echo "=== INICIANDO CONFIGURAÇÃO DO SERVIDOR PAPER ==="

# Aceitar EULA do Minecraft
echo "eula=true" > eula.txt

# 1. Baixar Playit.gg para liberação de IP/Portas
if [ ! -f "playit" ]; then
    echo "-> Baixando Playit.gg Agent..."
    curl -SsL https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -o playit
    chmod +x playit
fi

# 2. Baixar a versão mais recente do PaperMC (1.20.4)
if [ ! -f "paper.jar" ]; then
    echo "-> Baixando PaperMC (Java 21 / 1.20.4)..."
    curl -SsL https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/496/downloads/paper-1.20.4-496.jar -o paper.jar
fi

# 3. Criar pasta de plugins e baixar GeyserMC + Floodgate (Suporte Bedrock/Celular)
mkdir -p plugins

if [ ! -f "plugins/Geyser-Paper.jar" ]; then
    echo "-> Baixando Plugin GeyserMC (Suporte a Bedrock)..."
    curl -SsL https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -o plugins/Geyser-Paper.jar
fi

if [ ! -f "plugins/Floodgate-Paper.jar" ]; then
    echo "-> Baixando Plugin Floodgate (Autenticação Bedrock)..."
    curl -SsL https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -o plugins/Floodgate-Paper.jar
fi

# 4. Iniciar Playit em segundo plano
echo "-> Iniciando tunelamento Playit.gg..."
if [ -n "$PLAYIT_SECRET_KEY" ]; then
    ./playit --secret "$PLAYIT_SECRET_KEY" &
else
    ./playit &
fi

# 5. Iniciar Servidor PaperMC otimizado
echo "-> Ligando Servidor de Minecraft Paper..."
exec java -Xms256M -Xmx420M \
    -XX:+UseG1GC \
    -XX:+UnlockExperimentalVMOptions \
    -XX:G1NewSizePercent=20 \
    -XX:G1ReservePercent=20 \
    -XX:MaxGCPauseMillis=50 \
    -XX:G1HeapRegionSize=32M \
    -jar paper.jar nogui
