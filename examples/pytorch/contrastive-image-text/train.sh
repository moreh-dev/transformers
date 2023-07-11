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
--dataset_name ydshieh/coco_dataset_script \
--dataset_config_name 2017 \
--remove_unused_columns False \
--learning_rate 5e-5 \
--warmup_steps="0" \
--weight_decay 0.1 \
--num_train_epochs 3 \
--evaluation_strategy epoch \
--overwrite_output \
--load_best_model_at_end True \
--save_total_limit 2 \
--save_strategy epoch \
--seed 0 \
--data_dir /nas/common_data/data/coco \
"

python3 run_clip.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file