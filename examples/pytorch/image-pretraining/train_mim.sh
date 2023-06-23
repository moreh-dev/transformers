model=google/vit-base-patch16-224-in21k
batch_size=128
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
--label_names bool_masked_pos \
--remove_unused_columns False \
--learning_rate 2e-5 \
--num_train_epochs 3 \
--logging_strategy steps \
--logging_steps 10 \
--evaluation_strategy epoch \
--overwrite_output \
--load_best_model_at_end True \
--save_total_limit 3 \
--save_strategy epoch \
--seed 1337 \
--weight_decay 0.05 \
"

## Using moreh device
export MOREH_VISIBLE_DEVICE=$device_id

python3 run_mim.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file