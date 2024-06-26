#!/bin/bash
model=openmmlab/upernet-convnext-base
batch_size=16
device_id=0

while getopts m:b:g: flag
do
    case "${flag}" in
        m) model=${OPTARG};;
        b) batch_size=${OPTARG};;
        g) device_id=${OPTARG};;
    esac
done

echo Running $model with batch size $batch_size on device $device_id

LOG_DIR="./logs"
OUTPUT_DIR="./outputs"
log_file=$LOG_DIR/$model.log
output_dir=$OUTPUT_DIR/$model

mkdir -p "$(dirname $log_file)"
mkdir -p "$(dirname $output_dir)"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

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

python3 run_semantic_segmentation.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file