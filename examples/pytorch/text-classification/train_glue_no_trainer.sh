#!/bin/bash

# Defaul values:
model=bert-base-uncased
batch_size=64
device_id=1
task_name=mrpc

while getopts m:b:g: flag
do
    case "${flag}" in
        m) model=${OPTARG};;
        b) batch_size=${OPTARG};;
        g) device_id=${OPTARG};;
    esac
done

echo Running $model with batch size $batch_size on device $device_id

task_list=(
    "mrpc"
    "cola"
    "sst2"
    "stsb"
    "qqp"
    "mnli"
    "qnli"
    "rte"
    "wnli"
)

LOG_DIR="./logs"
OUTPUT_DIR="./outputs"
log_file=$LOG_DIR/$model.log
output_dir=$OUTPUT_DIR/$model

mkdir -p "$(dirname $log_file)"
mkdir -p "$(dirname $output_dir)"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

export TASK_NAME=$task_name

args="
--learning_rate 3e-5 \
--num_train_epochs 2 \
--max_length 384 \
--with_tracking
--seed 42
"

python run_glue_no_trainer.py \
  --model_name_or_path $model \
  --task_name ${TASK_NAME} \
  --per_device_train_batch_size $batch_size \
  --per_device_eval_batch_size $batch_size \
  --output_dir $output_dir \
  $args \
  2>&1 | tee $log_file