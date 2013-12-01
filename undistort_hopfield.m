%%%--------------------------------------------------------------------------%%
%% A very simple example of a Hopfield network applied to image undistortion %%
%%%--------------------------------------------------------------------------%%
function y = undistort_hopfield(varargin)
argc = length(varargin)
  if argc == 1
	img = varargin{1};
  else
	disp 'Specify an input file: binary image.'
        exit;
  end;
% Clear environment
close all; clc;
%% Load binary images
image=imread(img);
%% Convert them from 0,1 to -1,1 representation
image=double(image)*2-1;;
%% Append images as a columns (add more if you want)
a=image(:);
% Init
size1=size(image);
w=zeros(length(a));
%% Calculate weights (wij)
for i=1:min(size(a))
    w=w+a(:,i)*a(:,i)';
end
%% Set diagonal (wii) to 0
w=w-diag(diag(w));

%% Artificially create a corrupted version
pattern=1; %% Set pattern to one of the loaded images
threshold=0.7; %% [0.5,1] Change this to vary the amount of noise

noise=rand(length(a),1);
noise=noise>threshold; %% Elements to be corrupted
a_corr=a(:,pattern); %% Corrupted input
%% Swap the value of the corrupted 
for i=1:length(a)
    if noise(i)
        if a_corr(i)==1
            a_corr(i)=-1;
        else
            a_corr(i)=1;
        end
    end
    
end
%%Show corrupted
figure(1)
set(1,'Name','Corrupted Input')
imshow(reshape(sign(a_corr),size1));
dist_img=a_corr;


%% Let the trained hopfield network recover the image
iterations=10000;

for i=1:iterations

    a_rec=sign(w*a_corr); %% Calculate new output
    if(a_rec==a_corr) %% Did the network converge?
        fprintf('Done\n')
        break
    else
        a_corr=a_rec;   %% Set output as new input 
    end
%    if(i<10)
%        fprintf('Press a button for next iteration\n')
%        pause
%    end

end
figure(2)   
a_rec_show=(a_rec+1)/2;
set(2,'Name','Recovered Input')
imshow(reshape(a_rec,size1));
