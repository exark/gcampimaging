function m = cellseg_sk(x,zoom, cellID)

xi = interp2(x,1);

N = (size(xi,1)-1)/2;

[xx,yy]=meshgrid(-N:N,-N:N);
[fx,fy] = gradient(xi);

r = sqrt(xx.^2+yy.^2);

th = linspace(0,2*pi,50);

zoomCorrection=1;  %use 1 if UCLA data
if zoom==4,
    zoomCorrection=2;
end

for(i=1:20*zoomCorrection) %%UCLA elaine's data: (i=1:20)
    idx = find(r(:)>i-1 & r(:)<=i);
    m(i) = mean(xi(idx));
end

[M,i] = max(m);

m = m./sum(m);
rhat = sum(m.*(0.5:1:20*zoomCorrection-0.5));

p = rhat*exp(1i*th);

px = real(p);
py = imag(p);

% clf
% figure();
% imagesc(-N:N,-N:N,xi);
% hold on;

delta = .25; %UCLA data
if zoom==3,
    delta = .45; %sk
end

try
    for i=1:400%(i=1:400*zoomcorrection) %(i=1:400) UCLA
        Fx = diag(fx(N+1+round(py),N+1+round(px)))';
        Fy = diag(fy(N+1+round(py),N+1+round(px)))';
        px = px +delta*Fx;
        py = py +delta*Fy;
        %plot(px,py,'y.')
    end
catch
    disp('FX diag trouble with cell:')
    cellID
    i
end

% plot(px,py,'-or')
% hold off

m = full(sparse(N+1+round(py),N+1+round(px),1,size(xi,1),size(xi,2)));
m = (m>0);
m = imdilate(m,strel('disk',2)); %UCLA
if zoom==3,
    m = imdilate(m,strel('disk',4)); %sk
end

m = m(1:2:end,1:2:end);



