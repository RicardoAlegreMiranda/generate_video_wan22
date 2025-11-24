#!/bin/bash

set -e

echo "================================================"
echo "🚀 Iniciando ComfyUI Wan2.2 Serverless Worker"
echo "================================================"

# Verificar Network Volume
echo "🔍 Verificando Network Volume..."
if [ ! -d "/runpod-volume/models" ]; then
    echo "❌ ERROR: Network Volume no montado correctamente"
    echo "Ruta esperada: /runpod-volume/models"
    echo ""
    echo "Solución:"
    echo "1. Verifica que el Network Volume esté conectado al endpoint"
    echo "2. Ejecuta setup_volume.sh en un pod temporal"
    exit 1
fi

# Verificar checkpoint v10-nsfw
echo "🔍 Verificando checkpoint v10-nsfw..."
CHECKPOINT="/runpod-volume/models/diffusion_models/wan2.2-i2v-rapid-aio-v10-nsfw.safetensors"
if [ ! -f "$CHECKPOINT" ]; then
    echo "❌ ERROR: Checkpoint no encontrado"
    echo "Ubicación esperada: $CHECKPOINT"
    echo ""
    echo "Ejecuta: bash setup_volume.sh"
    exit 1
else
    SIZE=$(du -h "$CHECKPOINT" | cut -f1)
    echo "✅ Checkpoint encontrado: $SIZE"
fi

# Verificar modelos auxiliares
echo "🔍 Verificando modelos auxiliares..."
MODELS=(
    "/runpod-volume/models/vae/Wan2_1_VAE_bf16.safetensors"
    "/runpod-volume/models/clip_vision/clip_vision_h.safetensors"
    "/runpod-volume/models/text_encoders/umt5-xxl-enc-bf16.safetensors"
)

for MODEL in "${MODELS[@]}"; do
    if [ ! -f "$MODEL" ]; then
        echo "⚠️  WARNING: $(basename $MODEL) no encontrado"
    else
        echo "✅ $(basename $MODEL) OK"
    fi
done

echo ""
echo "🎬 Iniciando ComfyUI..."
cd /ComfyUI
python main.py --listen 0.0.0.0 --port 8188 &

# Esperar a que ComfyUI esté listo
echo "⏳ Esperando a que ComfyUI inicie..."
sleep 15

echo "🤖 Iniciando RunPod handler..."
python -u /handler.py
