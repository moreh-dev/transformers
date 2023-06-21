#!/bin/bash
while getopts m:b:g: flag
do
    case "${flag}" in
        m) model=${OPTARG};;
        b) batch_size=${OPTARG};;
        g) device_id=${OPTARG};;
    esac
done

LOG_DIR="./logs"
OUTPUT_DIR="./outputs"
log_file=$LOG_DIR/$model.log
output_dir=$OUTPUT_DIR/$model

mkdir -p "$(dirname $log_file)"
mkdir -p "$(dirname $output_dir)"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

## Note:
# With bart model replace source_lang and target_lang line in args with :     
#   --source_lang en_XX \
#   --target_lang ro_RO \

args="
--do_train \
--do_eval \
--source_lang en \
--target_lang ro \
--dataset_name wmt16 \
--dataset_config_name ro-en \
--overwrite_output_dir \
--predict_with_generate
--seed 42 \
"

python run_translation.py \
  --model_name_or_path=$model \
  --per_device_train_batch_size=$batch_size \
  --per_device_eval_batch_size=$batch_size \
  --source_prefix "translate English to Romanian: " \
  --output_dir $output_dir \
  $args 
  2>&1 | tee $log_file
