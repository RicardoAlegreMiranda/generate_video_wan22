#!/bin/bash

# setup_volume.sh - Script para poblar el Network Volume
# Ejecutar conectándote vía SSH a un pod con el volume montado

set -e  # Salir si hay errores

BASE_PATH="/runpod-volume/models"

echo "================================================"
echo "🚀 Configurando Network Volume para Wan2.2 v10"
echo "================================================"

# Crear estructura de carpetas
echo "📁 Creando estructura de directorios..."
mkdir -p $BASE_PATH/{diffusion_models,vae,clip_vision,text_encoders,loras}

# Verificar espacio disponible
echo "💾 Espacio disponible en el volume:"
df -h /runpod-volume

echo ""
echo "⬇️  Descargando checkpoint principal v10-nsfw (~14GB)..."
wget --show-progress \
    https://huggingface.co/Phr00t/WAN2.2-14B-Rapid-AllInOne/resolve/main/v10/wan2.2-i2v-rapid-aio-v10-nsfw.safetensors \
    -O $BASE_PATH/diffusion_models/wan2.2-i2v-rapid-aio-v10-nsfw.safetensors

echo ""
echo "⬇️  Descargando CLIP Vision..."
wget --show-progress \
    https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors \
    -O $BASE_PATH/clip_vision/clip_vision_h.safetensors

echo ""
echo "⬇️  Descargando Text Encoder..."
wget --show-progress \
    https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors \
    -O $BASE_PATH/text_encoders/umt5-xxl-enc-bf16.safetensors

echo ""
echo "⬇️  Descargando VAE..."
wget --show-progress \
    https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors \
    -O $BASE_PATH/vae/Wan2_1_VAE_bf16.safetensors

echo ""
echo "⬇️  Descargando LoRAs Lightning (opcionales)..."
wget --show-progress \
    https://huggingface.co/lightx2v/Wan2.2-Lightning/resolve/main/Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1/high_noise_model.safetensors \
    -O $BASE_PATH/loras/high_noise_model.safetensors

wget --show-progress \
    https://huggingface.co/lightx2v/Wan2.2-Lightning/resolve/main/Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1/low_noise_model.safetensors \
    -O $BASE_PATH/loras/low_noise_model.safetensors

echo ""
echo "✅ ¡Descarga completada!"
echo ""
echo "📊 Verificando archivos descargados:"
echo "================================================"
ls -lh $BASE_PATH/diffusion_models/
ls -lh $BASE_PATH/vae/
ls -lh $BASE_PATH/clip_vision/
ls -lh $BASE_PATH/text_encoders/
ls -lh $BASE_PATH/loras/

echo ""
echo "💾 Espacio usado:"
du -sh $BASE_PATH

echo ""
echo "================================================"
echo "✨ Network Volume listo para usar"
echo "================================================"
