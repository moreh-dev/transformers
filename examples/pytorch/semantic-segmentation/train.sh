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
--learning_rate 5e-5 \
--num_train_epochs 3 \
--logging_strategy steps \
--logging_steps 100 \
--overwrite_output \
--use_auth_token True \
--save_total_limit 2 \
--save_strategy epoch \
--seed 1337 \
--skip_memory_metrics False \
--remove_unused_columns False \
--report_to none \
--learning_rate 0.00006 \
--lr_scheduler_type polynomial \
--evaluation_strategy steps \
--max_steps 10000 \
--evaluation_strategy epoch \
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

python3 run_semantic_segmentation.py \
    --model_name_or_path $MODEL \
    --per_device_eval_batch_size $BATCH_SIZE \
    --per_device_train_batch_size $BATCH_SIZE \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file