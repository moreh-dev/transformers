model=$1
batch_size=$2
device_id=$3
task_name=${4:-cola}

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

log_file=$LOG_DIR/$model.log
output_dir=$OUTPUT_DIR/$model

mkdir -p "$(dirname $log_file)"
mkdir -p "$(dirname $output_dir)"

args="
--do_train \
--do_eval \
--learning_rate 3e-5 \
--num_train_epochs 2 \
--logging_strategy steps \
--logging_steps 100 \
--max_seq_length 384 \
--overwrite_output_dir \
--save_strategy epoch \
--save_total_limit 2 \
--seed 42
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

export TASK_NAME=$task_name

python run_glue.py \
  --model_name_or_path $model \
  --task_name $TASK_NAME \
  --per_device_train_batch_size $batch_size \
  --per_device_eval_batch_size $batch_size \
  --output_dir $output_dir \
  $args \
  2>&1 | tee $log_file