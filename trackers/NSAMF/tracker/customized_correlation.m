function kxy = customized_correlation(x, y, param)
    switch param.kernel_type
    case 'gaussian',
        kxy = gaussian_correlation(x, y, param.kernel_sigma);
    case 'polynomial',
        kxy = polynomial_correlation(x, y, param.kernel_poly_a, kernel_poly_b);
    case 'linear',
        kxy = linear_correlation(x, y);
    end
end