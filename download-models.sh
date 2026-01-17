#!/bin/bash
# Auto-generated model download script
# Downloads models to network volume on first startup

set -e

MODELS_DIR="/runpod-volume/models"
TOTAL_START=$(date +%s.%N)

echo "══════════════════════════════════════════════════════════════"
echo "  🚀 MODEL DOWNLOAD - $(date '+%Y-%m-%d %H:%M:%S')"
echo "══════════════════════════════════════════════════════════════"

# Create directories
mkdir -p "$MODELS_DIR/checkpoints" "$MODELS_DIR/vae" "$MODELS_DIR/clip"
mkdir -p "$MODELS_DIR/loras" "$MODELS_DIR/controlnet" "$MODELS_DIR/unet"

DOWNLOADED=0
SKIPPED=0

download_model() {
    local name="$1"
    local path="$2"
    local url="$3"
    local use_hf="$4"
    local hf_repo="$5"
    local hf_file="$6"
    
    if [ -f "$path" ]; then
        echo "✅ SKIP: $name - exists"
        ((SKIPPED++))
        return 0
    fi
    
    echo "📥 Downloading: $name"
    local start=$(date +%s.%N)
    
    if [ "$use_hf" = "true" ]; then
        local dir=$(dirname "$path")
        huggingface-cli download "$hf_repo" "$hf_file" --token "$HF_TOKEN" --local-dir "$dir" --local-dir-use-symlinks False 2>&1
    else
        wget -q --show-progress -O "$path" "$url" 2>&1
    fi
    
    local end=$(date +%s.%N)
    local duration=$(echo "$end - $start" | bc)
    echo "   Done in ${duration}s"
    ((DOWNLOADED++))
}

download_model "flux1-redux-dev.safetensors" "$MODELS_DIR/checkpoints/flux1-redux-dev.safetensors" "" "true" "black-forest-labs/FLUX.1-Redux-dev" "flux1-redux-dev.safetensors"
download_model "siglip-so400m-patch14-384.safetensors" "$MODELS_DIR/clip/siglip-so400m-patch14-384.safetensors" "https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors" "false"
download_model "ae.safetensors" "$MODELS_DIR/vae/ae.safetensors" "" "true" "black-forest-labs/FLUX.1-dev" "ae.safetensors"
download_model "flux1-dev.safetensors" "$MODELS_DIR/checkpoints/flux1-dev.safetensors" "" "true" "black-forest-labs/FLUX.1-dev" "flux1-dev.safetensors"
download_model "clip_l.safetensors" "$MODELS_DIR/clip/clip_l.safetensors" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" "false"
download_model "diffusion_pytorch_model.safetensors" "$MODELS_DIR/controlnet/diffusion_pytorch_model.safetensors" "https://huggingface.co/Shakker-Labs/FLUX.1-dev-ControlNet-Union-Pro-2.0/resolve/main/diffusion_pytorch_model.safetensors" "false"
download_model "MM008_LyCORIS_DS02A_v1-000026.safetensors" "$MODELS_DIR/loras/MM008_LyCORIS_DS02A_v1-000026.safetensors" "" "true" "dvhouw/CLOUD_SYNC" "MM008_LyCORIS_DS02A_v1-000024.safetensors"
download_model "PNF001_LyCORIS_PNFB3TT4S_DS02_v1-000024.safetensors" "$MODELS_DIR/loras/PNF001_LyCORIS_PNFB3TT4S_DS02_v1-000024.safetensors" "" "true" "dvhouw/CLOUD_SYNC" "PNF001_LyCORIS_PNFB3TT4S_DS02_v1-000024.safetensors"

TOTAL_END=$(date +%s.%N)
TOTAL_DURATION=$(echo "$TOTAL_END - $TOTAL_START" | bc)

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  ✅ Downloaded: $DOWNLOADED | Skipped: $SKIPPED"
echo "  ⏱️  Total: ${TOTAL_DURATION}s"
echo "══════════════════════════════════════════════════════════════"
