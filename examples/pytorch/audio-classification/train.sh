while getopts m:b:g: flag
do
    case "${flag}" in
        m) model=${OPTARG};;
        b) batch_size=${OPTARG};;
        g) device_id=${OPTARG};;
    esac
done

LOG_DIR=./logs
OUTPUT_DIR=./outputs
log_file=$LOG_DIR/$model.log
output_dir=$OUTPUT_DIR/$model

mkdir -p "$(dirname $log_file)"
mkdir -p "$(dirname $output_dir)"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

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

python3 run_audio_classification.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file