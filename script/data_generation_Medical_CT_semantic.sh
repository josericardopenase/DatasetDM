# CUDA_VISIBLE_DEVICES=3 
# Semantic Segmentation  CityScapes
CUDA_VISIBLE_DEVICES=1 python tools/parallel_generate_Semantic_Medical_CT.py --sd_ckpt './models/ldm/stable-diffusion-v1/stable_diffusion.ckpt' --grounding_ckpt './checkpoint/Train_1_images_t1_attention_transformer_Cityscapes_10layers/latest_checkpoint.pth' --n_each_class 2 --outdir './DataDiffusion/Semantic_Medical_CT/' --thread_num 1 --H 512 --W 512