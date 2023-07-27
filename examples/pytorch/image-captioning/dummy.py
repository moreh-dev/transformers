import torch

memory_key_padding_mask = torch.full((32, 197), fill_value=False, device='cuda')

print(memory_key_padding_mask.dtype)