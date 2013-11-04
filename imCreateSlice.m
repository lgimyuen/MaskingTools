function [ slices, combined ] = imCreateSlice( im, varargin )
%IMCREATESLICE Allow user to create freehand binary mask slice of the image
%
%Syntax:
%   slices = imCreateSlice(im);
%   slices = imCreateSlice(im, [5 3 1]);
%   [slices, combined] = imCreateSlice(im);
%   [slices, combined] = imCreateSlice(im, [5 3 1]);
%
%Description:
%   [slices, combined] = imCreateSlice( im [, channels] ) will create a 
%   figure displaying the input images. If the images is more than 3 
%   channel, only the first 3 channels is displayed. User will then use 
%   freehand to draw the mask they want and then double click. 
%   A slice will be created. A question dlg will popup and ask user 
%   whether they want to 
%       1. Continue create another slices 
%       2. Quit All the slices will be return as cell of slices.
%
%Input Parameters:
%   im:         M x N x K image. M, N is the row and columns of the image. K is
%               number of channels. For K > 3, only the first 3 is displayed.
%   
%   varargin:   an array of length 3 x 1. Indicating the channels to display 
%
%Returned Value:
%   slices:     cell of matrix I cells of M x N binary images will be returned.
%               Each cell contains the M x N binary mask drawn by user
%   
%   combined:   all binary images superimposed together into one M x N binary
%               image
%
%
%Example:
%   slices = imCreateSlice(im);
%   slices = imCreateSlice(im, [5 3 1]);
%   [slices, combined] = imCreateSlice(im);
%   [slices, combined] = imCreateSlice(im, [5 3 1]);

figure;
k = size(im, 3);

if length( nargin ) < 1
    error('imCreateSlice:argChk', 'Wrong number of input arguments. An image expected')
end

if length(varargin) > 1
    error('imCreateSlice:argChk', 'Wrong number of input arguments. Only Image and Channels expected')
end

if k>1
    
    imagesc(im(:,:,varargin{1}));
    %colormap('');
    axis image;
else
    imagesc(im);
    colormap('gray');
    axis image;
end

slices = {};

choice = 'Yes';
while strcmpi(choice, 'Yes')
    h = imfreehand;

    wait(h);
    bw = h.createMask;

    slices = [slices; bw];
    choice = questdlg('Continue drawing a new mask?', ...
                    'Continue?', ...
                    'Yes', ...
                    'Delete Previous and Continue', ...
                    'Stop and Quit', 'Yes');
            
    if strcmpi(choice, 'Delete Previous and Continue')
        slices(length(slices))= [];
        choice = 'Yes';
        delete(h);
    end
end

combined = zeros(size(im,1), size(im,2));
for i=1:length(slices)
    combined = combined | slices{i};
end

end

