model=Helsinki-NLP/opus-mt-en-ro
batch_size=32
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
    --preprocessing_num_workers \
    --overwrite_output_dir \
"

accelerate launch run_translation_no_trainer.py \
    --model_name_or_path $model \
    --source_lang en \
    --target_lang ro \
    --dataset_name wmt16 \
    --dataset_config_name ro-en \
    --per_device_train_batch_size $batch_size \
    --per_device_eval_batch_size $batch_size \
    --output_dir $output_dir
    2>&1 | tee $log_file