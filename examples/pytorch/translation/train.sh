#!/bin/bash
LOG_DIR="./logs"
OUTPUT_DIR="./outputs"
mkdir -p $LOG_DIR
mkdir -p $OUTPUT_DIR
##    SETTINGS     ## 
MODEL=$1
BATCH_SIZE=$2
device_id=$3
log_file="${LOG_DIR}/${model_name}.log"
output_dir="$OUTPUT_DIR/$model_name"

## END OF SETTINGS ##

export TRANSFORMERS_CACHE=/nas/huggingface_pretrained_models
export HF_DATASETS_CACHE=/nas/common_data/huggingface

args="
--do_train \
--do_eval \
--source_lang en \
--target_lang ro \
--dataset_name wmt16 \
--dataset_config_name ro-en \
--overwrite_output \
--save_total_limit 2 \
--predict_with_generate \
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

python3 run_translation.py \
    --model_name_or_path $MODEL \
    --per_device_eval_batch_size $BATCH_SIZE \
    --per_device_train_batch_size $BATCH_SIZE \
    --output_dir $output_dir \
    --do_train \
    --do_eval \
    --source_lang en \
    --target_lang ro \
    --dataset_name wmt16 \
    --dataset_config_name ro-en \
    --overwrite_output \
    --save_total_limit 2 \
    --predict_with_generate \
    2>&1 | tee $log_file