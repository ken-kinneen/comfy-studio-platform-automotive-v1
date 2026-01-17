# Auto-generated ComfyUI Worker
FROM runpod/worker-comfyui:5.5.0-base

# Install huggingface-cli
RUN pip install -q huggingface_hub

# ============================================
# CUSTOM NODES
# ============================================
WORKDIR /comfyui/custom_nodes

RUN git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git && cd ComfyUI-Advanced-ControlNet && pip install -r requirements.txt || true
RUN git clone https://github.com/cubiq/ComfyUI_essentials.git && cd ComfyUI_essentials && pip install -r requirements.txt || true
RUN git clone https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl.git && cd ComfyUI_AdvancedRefluxControl && pip install -r requirements.txt || true
RUN git clone https://github.com/sipherxyz/comfyui-art-venture.git && cd comfyui-art-venture && pip install -r requirements.txt || true
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use.git && cd ComfyUI-Easy-Use && pip install -r requirements.txt || true
RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git && cd ComfyUI_Comfyroll_CustomNodes && pip install -r requirements.txt || true

WORKDIR /

# ============================================
# MODEL SYMLINKS TO NETWORK VOLUME
# ============================================
RUN rm -rf /comfyui/models/checkpoints /comfyui/models/vae /comfyui/models/clip \
    /comfyui/models/loras /comfyui/models/controlnet /comfyui/models/unet && \
    ln -s /runpod-volume/models/checkpoints /comfyui/models/checkpoints && \
    ln -s /runpod-volume/models/vae /comfyui/models/vae && \
    ln -s /runpod-volume/models/clip /comfyui/models/clip && \
    ln -s /runpod-volume/models/loras /comfyui/models/loras && \
    ln -s /runpod-volume/models/controlnet /comfyui/models/controlnet && \
    ln -s /runpod-volume/models/unet /comfyui/models/unet

# ============================================
# STARTUP SCRIPTS
# ============================================
COPY download-models.sh /download-models.sh
COPY start.sh /start-custom.sh
RUN chmod +x /download-models.sh /start-custom.sh

CMD ["/start-custom.sh"]
