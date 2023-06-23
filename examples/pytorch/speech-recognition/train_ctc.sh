model=facebook/wav2vec2-large-xlsr-53
batch_size=56
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
	--dataset_name="common_voice" \
	--dataset_config_name="tr" \
	--train_split_name="train+validation" \
	--eval_split_name="test" \
	--max_steps="5000" \
	--gradient_accumulation_steps="2" \
	--logging_steps="25" \
	--learning_rate="3e-4" \
	--warmup_steps="500" \
	--evaluation_strategy="steps" \
	--eval_steps="100" \
	--save_strategy="steps" \
	--save_steps="400" \
	--preprocessing_num_workers="16" \
	--length_column_name="input_length" \
	--max_duration_in_seconds="30" \
	--text_column_name="sentence" \
	--freeze_feature_encoder="False" \
	--gradient_checkpointing \
	--group_by_length \
	--overwrite_output_dir \
	--do_train \
	--do_eval \
    --chars_to_ignore , ? . ! - \; \: \" “ % ‘ ” � \
	--save_total_limit 2 \
    --num_train_epochs="3" \
"

python3 run_speech_recognition_ctc.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
    2>&1 | tee $log_file