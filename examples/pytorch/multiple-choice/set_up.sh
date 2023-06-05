conda env create -n multiple_choice python=3.8
conda activate multiple_choice


update-moreh --force --torch 1.10.0


PATH = huggingface/transformers/examples/pytorch/multiple-choice
echo "installing requirements.."
pip install -r requirements.txt


export TRANSFORMERS_CACHE=/nas/huggingface_pretrained_models
export HF_DATASETS_CACHE=/nas/common_data/huggingface