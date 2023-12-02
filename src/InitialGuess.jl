
const DEFAULT_BETA = 2.

"""
Define inital guess for various dose-response models. 
Assumes by default that `data` is a DataFrame with two columns called x and y, corresponding to exposure concentration and mean relative response, respectively.
$(TYPEDSIGNATURES)
"""
function set_intguess(model_label::String, data::D; x = :x, y = :y) where D<:DataFrame
    let edist, bdist
        # if effect >= 50% as been observed
        if maximum(data.y)>=0.5
            # test concentration closest to EC50 = prior mean of EC50
            mean_response = combine(groupby(data, x), y=>mean)
            e = mean_response[:,1][argmin(abs.(mean_response[:,2].-0.5))]
        # otherwise, take 2-times the highest test concentration as mean
        # TODO: there has to be a better way to do this...to be refined
        else
            e = maximum(data.x)*2
        end
        # log-logistic and weibull model
        if model_label=="LL2"
            return e,DEFAULT_BETA
        elseif model_label=="WB2"
            return e,DEFAULT_BETA
        # biphasic model: intguess for both inflection points at 25% at 75% effect
        elseif model_label=="LLBP5"
            e1 = data[:,1][argmin(abs.(data[:,2].-0.25))]
            e2 = data[:,1][argmin(abs.(data[:,2].-0.75))]
            return [
                e1,
                bdist, 
                e2,
                bdist,
                0.5  
            ]
        # asymmetric: same as for log-logistic, but two slope parameters
        elseif model_label=="LLAS3"
            return [
                e, 
                DEFAULT_BETA
            ]
        # cedergreen-ritz streibig: same as for log-logistic, 
        # parameter α between 0.25 and 1.0 (cf. original Cedergreen-Ritz-Streibig publication), -> mean is 0.625
        # parameter f between 0 and 1.5-times the maximum observed hormetic effect -> mean is half of maximum hormetic
        elseif model_label=="CRS4"
            return [
                Uniform(0.625),
                bdist,
                edist,
                ((maximum(data[:,2])-1)*1.5)/2
            ]
        else
            error("Model $model_label not implemented.")
        end
    end
end