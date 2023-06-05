export TRANSFORMERS_CACHE=/nas/huggingface_pretrained_models
export HF_DATASETS_CACHE=/nas/common_data/huggingface


input_file=${1:-models_batchsize.txt}
[[ ! -f $input_file ]] && echo "${input_file} not exist" && exit 1

while read model batch_size ; do
    echo Running: $model
    echo Batchsize: $batch_size
    bash train.sh $model $batch_size
done < $input_file

echo Done