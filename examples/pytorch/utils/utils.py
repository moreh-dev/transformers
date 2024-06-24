# Log number of parameters function
def get_num_parameters(model):
    num_params = 0
    for param in model.parameters():
        num_params += param.numel()
    # in million
    num_params /= 10**6
    return num_params