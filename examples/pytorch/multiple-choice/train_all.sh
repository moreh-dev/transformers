input_file=${1:-model_batchsize.txt}
[[ ! -f $input_file ]] && echo "${input_file} not exist" && exit 1

while read model batch_size ; do
    echo Running: $model
    echo Batchsize: $batch_size
    bash train.sh $model $batch_size
done < $input_file

echo Done