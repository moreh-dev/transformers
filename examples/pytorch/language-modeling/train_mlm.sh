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
--dataset_name wikitext \
--dataset_config_name wikitext-2-raw-v1 \
--do_train \
--do_eval \
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

python3 run_mlm.py \
    --model_name_or_path $MODEL \
    --per_device_eval_batch_size $BATCH_SIZE \
    --per_device_train_batch_size $BATCH_SIZE \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file