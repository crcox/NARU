function Y = rescale_nii(V,Y)
  if ~isa(Y,'double')
    Y = double(Y);
  end
  intercept = V.private.dat.scl_inter;
  slope = V.private.dat.scl_slope;
  if (isempty(slope) && isempty(intercept)) || (slope==1 && intercept==0)
    % No scaling required.
  elseif isempty(slope) || slope==1
    Y = Y + intercept;
  elseif isempty(intercept) || intercept==0
    Y = Y * slope;
  else
    Y = reshape([ones(numel(Y),1),Y(:)] * [intercept; slope], size(Y));
  end
end