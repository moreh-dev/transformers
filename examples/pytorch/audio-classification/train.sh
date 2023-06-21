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
--dataset_name superb \
--dataset_config_name ks \
--remove_unused_columns False \
--max_length_seconds 1 \
--learning_rate 3e-5 \
--attention_mask False \
--warmup_ratio 0.1 \
--num_train_epochs 3 \
--logging_strategy steps \
--gradient_accumulation_steps 4 \
--dataloader_num_workers 4 \
--logging_steps 10 \
--evaluation_strategy epoch \
--overwrite_output \
--load_best_model_at_end True \
--save_total_limit 2 \
--save_strategy epoch \
--seed 0 \
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

python3 run_audio_classification.py \
    --model_name_or_path $MODEL \
    --per_device_eval_batch_size $BATCH_SIZE \
    --per_device_train_batch_size $BATCH_SIZE \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file