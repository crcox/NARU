function b = ispositiveinteger(x)
    b = (x > 0) && (mod(x,1) == 0);
end