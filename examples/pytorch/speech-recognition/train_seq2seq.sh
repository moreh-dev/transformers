model=$1
batch_size=$2
output_dir=$3


args="
	--dataset_name="librispeech_asr" \
	--dataset_config_name="clean" \
	--train_split_name="train.100" \
	--eval_split_name="validation" \
	--preprocessing_num_workers="16" \
	--length_column_name="input_length" \
	--overwrite_output_dir \
	--num_train_epochs="5" \
	--gradient_accumulation_steps="8" \
	--learning_rate="3e-4" \
	--warmup_steps="400" \
	--evaluation_strategy="steps" \
	--text_column_name="text" \
	--save_steps="400" \
	--eval_steps="400" \
	--logging_steps="10" \
	--save_total_limit="1" \
	--freeze_feature_encoder \
	--gradient_checkpointing \
	--group_by_length \
	--predict_with_generate \
	--generation_max_length="40" \
	--generation_num_beams="1" \
	--do_train --do_eval \
	--do_lower_case
"

python run_speech_recognition_seq2seq.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \
